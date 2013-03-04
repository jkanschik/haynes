class Admin::SynchronizeController < ApplicationController
  
  @@REMOTE_URL = "haynes-catalog.net"
  
  def incoming
    redirect_to("/") && return unless admin?

    latest_local_addition = Addition.find :first, :order => "created_at desc"
    time = latest_local_addition.created_at.strftime("%Y-%m-%dT%H:%M:%S")
    data = call_remote "get", "/admin/additions/since_created?created_at=#{time}"
    @additions = Hash.from_xml data
    @additions = @additions["nil_classes"] ? [] : @additions["additions"]
    
    latest_local_addition = User.find :first, :order => "created_at desc"
    time = latest_local_addition.created_at.strftime("%Y-%m-%dT%H:%M:%S")
    data = call_remote "get", "/admin/users/since_created?created_at=#{time}"
    @users = Hash.from_xml data
    @users = @users["nil_classes"] ? [] : @users["users"]
  end

  def update
    (params[:additions] || []).each do |id, action|
      if action == "U"
        data = call_remote "get", "/admin/additions/#{id}.xml"

        addition = Addition.new
        addition.from_xml data
        addition.id = id
        raise "Couldn't save Addition #{id}" unless addition.save_with_validation(false)
      end
    end

    (params[:users] || []).each do |id, action|
      if action == "U"
        data = call_remote "get", "/admin/users/#{id}.xml"

        user = User.new
        user.from_xml data
        user.id = id
        raise "Couldn't save User #{id}" unless user.save_with_validation(false)
      end
    end
    redirect_to :action => :incoming
  end

  def outgoing
    redirect_to("/") && return unless admin?
    
    # additions und users fehlen erst einmal

    other_thread = Thread.new {
      logger.info "Start thread for other data"
      @static = compare_records("Abbreviation", :label => "label")
      @static.concat compare_records("Addition", :label => "text")
      @static.concat compare_records("Code", :label => "label")
      @static.concat compare_records("Country", :label => "title")
      @static.concat compare_records("Instrumentation", :label => "label")
      @static.concat compare_records("Material", :label => "label")
      @static.concat compare_records("Problem", :label => "title")
      @static.concat compare_records("VersionComment", :label => "text")
      @static.concat compare_records("Quotation", :label => "label")
      @static.concat compare_records("Source", :label => "name")

      @libraries = compare_records("Library", :label => "label")
      @publishers = compare_records("Publisher", :label => "label")
 
      @composers = compare_with_group([
        {:entity => "Composer", :options => {:group_by => "id", :label => "name"}},
        {:entity => "Alia", :options => {:group_by => "composer_id", :label => "name"}}
      ])
    
      @documents = compare_with_group([
        {:entity => "Document", :options => {:group_by => "id", :label => "title"}},
        {:entity => "DocumentUsage", :options => {:group_by => "document_id", :label => "usage_id"}}
      ])
      logger.info "Thread for other data finished"
    }
    
    work_thread = Thread.new {
      logger.info "Start thread for work data"
      @works = compare_with_group([
        {:entity => "Work", :options => {:group_by => "id", :label => "title"}},
        {:entity => "ComposersWork", :options => {:group_by => "work_id", :label => "id"}},
        {:entity => "ComposersWorkVersion", :options => {:group_by => "work_id", :label => "id"}},
        {:entity => "Download", :options => {:group_by => "work_id", :label => "kind"}},
        {:entity => "InstrumentationsWork", :options => {:group_by => "work_id", :label => "id"}},
        {:entity => "InstrumentationsWorkVersion", :options => {:group_by => "work_id", :label => "id"}},
        {:entity => "LibrariesWork", :options => {:group_by => "work_id", :label => "id"}},
        {:entity => "LibrariesWorkVersion", :options => {:group_by => "work_id", :label => "id"}},
        {:entity => "PublishersWork", :options => {:group_by => "work_id", :label => "id"}},
        {:entity => "PublishersWorkVersion", :options => {:group_by => "work_id", :label => "id"}},
        {:entity => "QuotationsWork", :options => {:group_by => "work_id", :label => "id"}},
        {:entity => "WorkRelation", :options => {:group_by => "work_id", :label => "related_work_id"}},
        {:entity => "WorkVersion", :options => {:group_by => "work_id", :label => "title"}}
      ])
      logger.info "Thread for work data finished"
    }

    other_thread.join
    work_thread.join
  end

  def update_outgoing
    redirect_to("/") && return unless admin?
    
    ids = []
    (params[:records] || []).each do |r|
      entity = r[:entity]
      id = r[:id]
      case r[:method]
        when "put"
          logger.info "Update #{entity} #{id}"
          record = Kernel.const_get(entity).find id
          call_parameter = {entity => record.attributes}
          url = "/api/#{entity.tableize}/#{id}"
        when "post"
          logger.info "Create #{entity} #{id}"
          record = Kernel.const_get(entity).find id
          call_parameter = {entity => record.attributes}
          url = "/api/#{entity.tableize}"
        when "delete"
          logger.info "Delete #{entity} #{id}"
          url = "/api/#{entity.tableize}/#{id}"
        else
          logger.info "Unexpected method #{r[:method]}!"
          render :nothing => true, :status => :failure
      end
      call_remote r[:method], url, call_parameter
      ids << entity + id
    end
    logger.info "Update successful for #{ids.inspect}."
    render :update do |page|
      ids.each do |id|
        page.visual_effect :fade, id
      end
    end
  end

protected

  def compare_with_group(entities)
    result = []
    entities.each do |e|
      result.concat compare_records(e[:entity], e[:options])
    end
    result.group_by {|r| r[:group_by]}
  end

  def compare_records(entity, options)
    logger.info "Compare records for #{entity}"
    local_records = Kernel.const_get(entity).find(:all, :order => :id)
    remote_records = ActiveSupport::JSON.decode(call_remote("get", "/api/#{entity.tableize}/timestamps"))

    group_by = options[:group_by]
    label = options[:label]
  
    result = []
    index = 0
    remote_index = 0
    while index < local_records.size or remote_index < remote_records.size
        record = local_records[index]
        remote_record = remote_records[remote_index]
        if record and remote_record and record.id == remote_record["id"] 
          if record.updated_at.strftime("%Y-%m-%d %H:%M:%S") != remote_record["updated_at"]
            logger.debug "Changed detected for record id #{record.id}; local timestamp #{record.updated_at}, remote timestamp #{remote_record['updated_at']}"
            logger.debug "Local record data:  #{record.inspect}"
            result << {:type => entity, :type_of_change => "Changed", :id => record.id, :updated_at => record.updated_at, :group_by => group_by ? record.send(group_by) : nil, :label => label ? record.send(label) : nil}
          end
          remote_index += 1
          index += 1
        end
        if record.nil? or (record and remote_record and record.id > remote_record["id"])
          logger.debug "Remote record id #{remote_record['id']} missing in local db (locally deleted)"
          remote_index += 1
          result << {:type => entity, :type_of_change => "Deleted", :id => remote_record["id"], :updated_at => remote_record["updated_at"]}
        end
        if remote_record.nil? or (record and remote_record and record.id < remote_record["id"])
          logger.debug "Local record id #{record.id} missing in remote db (locally added)"
          logger.debug "Local record data:  #{record.inspect}"
          result << {:type => entity, :type_of_change => "Added", :id => record.id, :updated_at => record.updated_at, :group_by => group_by ? record.send(group_by) : nil, :label => label ? record.send(label) : nil}
          index += 1
        end
    end
    logger.info "Finished comparison of records for #{entity}, #{result.size()} changes found."
    result
  end

  def call_remote(verb, url, params=nil)
    headers = {"USER" => current_user.id.to_s, "PASSWORD" => current_user.password}
    logger.debug "Calling remote host with url #{url} and verb #{verb}"
    logger.debug "Parameters (nil: #{params.nil?}) #{params}."
    logger.debug "Header #{headers.inspect}."

    resp = Net::HTTP.start(@@REMOTE_URL) {|http| http.get(url, headers)} if verb == "get"
    resp = Net::HTTP.start(@@REMOTE_URL) {|http| http.delete(url, headers)} if verb == "delete"
    resp = Net::HTTP.start(@@REMOTE_URL) {|http| http.put(url, params.to_query, headers)} if verb == "put"
    resp = Net::HTTP.start(@@REMOTE_URL) {|http| http.post(url, params.to_query, headers)} if verb == "post"

    message = "Remote host sent response #{resp.code} #{resp.message}: \n#{resp.body}"
    if resp.class == Net::HTTPOK
      logger.debug message
    else
      logger.error message
      raise message
    end
    return resp.body
  end
end
