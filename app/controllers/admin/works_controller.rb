class Admin::WorksController < Admin::AdminController

  habtm_actions :work_relations,          :partial_location => :before
  habtm_actions :instrumentations_works,  :partial_location => :before
  habtm_actions :instruments_works,       :partial_location => :before
  habtm_actions :publishers_works,        :partial_location => :before
  habtm_actions :libraries_works,         :partial_location => :before
  habtm_actions :composers_works,         :partial_location => :before
  habtm_actions :quotations_works,        :partial_location => :before
  habtm_actions :downloads,               :partial_location => :before

  def show
    logger.debug "Invoked method WorksController.show"
    @work = Work.find(params[:id])
    get_versions
  end

  def edit
    logger.debug "Invoked method WorksController.edit"
    @work = Work.find(params[:id]) unless @work
    @composers = Composer.find(:all, :order => "name, first_name").map {|c| [c.full_name, c.id]}
    session[:work_relations] = @work.work_relations.dup
    session[:publishers_works] = @work.publishers_works.dup
    session[:libraries_works] = @work.libraries_works.dup
    session[:composers_works] = @work.composers_works.dup
    session[:instrumentations_works] = @work.instrumentations_works.dup
    session[:instruments_works] = @work.instruments_works.dup
    session[:quotations_works] = @work.quotations_works.dup
    session[:downloads] = @work.downloads.dup
    get_versions
  end

  def new
    logger.debug "Invoked method WorksController.new"
    @work = Work.new
    @composers = Composer.find(:all, :order => "name, first_name").map {|c| [c.full_name, c.id]}
    session[:work_relations] = @work.work_relations.dup
    session[:publishers_works] = @work.publishers_works.dup
    session[:libraries_works] = @work.libraries_works.dup
    session[:composers_works] = @work.composers_works.dup
    session[:instrumentations_works] = @work.instrumentations_works.dup
    session[:instruments_works] = @work.instruments_works.dup
    session[:quotations_works] = @work.quotations_works.dup
    session[:downloads] = @work.downloads.dup
  end



  def create
    logger.debug "Invoked method WorksController.create"
    if params[:create] == "Create"
      Work.transaction do
        @work = Work.create(params[:work])
        @work.work_relations = session[:work_relations]
        @work.publishers_works = session[:publishers_works]
        @work.libraries_works = session[:libraries_works]
        @work.composers_works = session[:composers_works]
        @work.instrumentations_works = session[:instrumentations_works]
        @work.instruments_works = session[:instruments_works]
        @work.quotations_works = session[:quotations_works]
        @work.downloads = session[:downloads]
        @work.save!
      end
      redirect_to :action => 'show', :id => @work
    else
      redirect_to :controller => "/", :action => 'index'
    end
  rescue ActiveRecord::RecordInvalid => e
    logger.info "The new work didn't validate: #{e}"
    @composers = Composer.find(:all, :order => "name, first_name").map {|c| [c.full_name, c.id]}
    session[:work_relations] = @work.work_relations.dup
    session[:publishers_works] = @work.publishers_works.dup
    session[:libraries_works] = @work.libraries_works.dup
    session[:composers_works] = @work.composers_works.dup
    session[:instrumentations_works] = @work.instrumentations_works.dup
    session[:instruments_works] = @work.instruments_works.dup
    session[:quotations_works] = @work.quotations_works.dup
    session[:downloads] = @work.downloads.dup
    render :action => 'new'
  end

  def edit_version_comment
    logger.debug "Invoked method WorksController.edit_version_comment"
    @work = Work.find(params[:id])
    version = @work.find_version((params[:version_id] || @work.version).to_i)
    diff = @work.compare_with_previous version.version
    @addition = Addition.find version.addition_id if version.addition_id
    @comment = VersionComment.find version.version_comment_id if version.version_comment_id
    @version = {
         :diff => diff,
         :updated_at => version.updated_at,
         :addition => @addition,
         :comment => @comment,
         :version => version.version}
    @version_comments = VersionComment.find_by_sql(
      "select version_comments.id as id, version_comments.text as text, count(work_versions.id) as count
       from version_comments left join work_versions on version_comments.id = work_versions.version_comment_id
       group by version_comments.id
       order by count desc, text asc"
       ).map {|comment| [comment.text, comment.id]}
  end

  def update_version_comment
    logger.debug "Invoked method WorksController.update_version_comment"
    if !params[:cancel]
      @work = Work.find(params[:id])
      version = @work.find_version(params[:version_id].to_i)
      # process comment
      comment_id = params[:comment][:id].to_i
      comment_id = VersionComment.create(params[:comment]).id if comment_id == -1
      comment_id = nil if comment_id == -2
      version.version_comment_id = comment_id
      # process addition
      addition_id = params[:addition][:id]
      addition_id = nil if addition_id == "-1"
      version.addition_id = addition_id
      # save
      version.save
    end
    redirect_to(:action => "show", :id => params[:id], :search_id => params[:search_id])
  end

  def update
    logger.debug "Invoked method WorksController.update"
    @work = Work.find(params[:id])
    
    addition_id = nil
    params.each_key {|p|
      addition_id = p[8, p.length] if p =~ /version_[0-9]*/
    }

    version = params[:version] || addition_id
    if version || params[:save] == "Save"
      Work.transaction do
        if version
          logger.info "A new version for work #{@work.id} is requested"
          logger.info "The version is based on " + (addition_id ? "comment #{addition_id}" : "no comment.")
          # create a version before and after update
          @work.create_version!
          logger.debug "Version has been created."
        else
          logger.info "A simple save of work #{@work.id} is requested, no version"
        end
        save_publishers(@work)
        save_libraries(@work)
        save_composers(@work)
        save_instrumentations(@work)
        save_instruments(@work)
        save_work_relations(@work)
        save_quotations(@work)
        save_downloads(@work)
        Work.without_locking do
          Work.without_revision do
            logger.debug "Update the attributes of the work."
            @work.update_attributes!(params[:work])
          end
        end
        if version
          logger.debug "Create a version to save the status after the update."
          @work.create_version!
          version = @work.find_version(@work.version)
          if addition_id
            version.addition_id = addition_id
            version.save
            # update state of addition if necessary
            logger.debug "Update the reference to the addition."
            addition = Addition.find addition_id
            addition.update_attribute(:state, "processed")
          end
        end
      end
    else
      logger.info "Edit of work #{@work} has been cancelled"
    end
    if version
      redirect_to :action => 'edit_version_comment', :id => @work, :version => @work.version, :search_id => params[:search_id]
    else
      redirect_to :action => 'show', :id => @work, :search_id => params[:search_id]
    end
  rescue ActiveRecord::RecordInvalid => e
    logger.warn "The work #{@work.id} didn't validate: #{e}"
    edit
    render :action => 'edit', :search_id => params[:search_id]
  end


  def change_done
    logger.debug "Invoked method WorksController.change_done"
    @work = Work.find(params[:id])
    if @work.done == "N"
      @work.done = "Y"
    elsif @work.done == "Y"
      @work.done = "P"
    elsif @work.done == "P"
      @work.done = "N"
    end
    Work.without_locking do
      Work.without_revision do
        @work.save
      end
    end
    redirect_to :action => 'show', :id => @work, :search_id => params[:search_id]
  end

  def add_comment
    if params[:commit] == 'Cancel'
      redirect_to :action => 'show', :id => params[:id]
      return
    end
    @errors = {}
    @work = Work.find(params[:id])
    @text = params[:text]
    return unless request.post?
    c = Addition.new
    c.text = @text
    c.user_id = current_user.id
    c.work = @work
    if c.save
      redirect_to :action => 'show', :id => @work
    else
      @errors[:text] = c.errors.on :text
    end
  end
  def addition_remove
    logger.info "Removing addition #{params[:addition_id]}"
    addition = Addition.find params[:id]
    addition.update_attribute(:state, "deleted")
    redirect_to :action => 'edit', :id => addition.work_id
  end

  # --------------------------------------------
  # Admin block
  # --------------------------------------------

  def admin_block_edit
    @work = Work.find(params[:id])
    render :partial => 'admin_block_edit', :layout => false 
  end
  def admin_block_show
    @work = Work.find(params[:id])
    render :partial => 'admin_block_show', :layout => false 
  end
  def admin_block_save
    @work = Work.find(params[:id])
    Work.without_locking do
      Work.without_revision do
        begin
          params[:work][:oboe] = Work.oboe_array_to_string params[:oboe]
          params[:work][:country] = Work.country_array_to_string params[:country]
          @work.update_attributes!(params[:work])
          render :partial => 'admin_block_show', :layout => false 
        rescue Exception => e
          logger.warn "Work #{@work.id} hasn't been saved because of exception #{e}."
          logger.warn e.backtrace.join("\n")
          render :partial => 'admin_block_edit', :layout => false
        end
      end
    end
  end

protected

  def save_publishers(work)
    PublishersWork.without_locking do
      PublishersWork.without_revision do
        logger.debug "Saving publishers_works from session..."
        session[:publishers_works].each do |pw|
          logger.debug "Saving publishers_work: #{pw.inspect}."
          pw.save
        end
        work.publishers_works = session[:publishers_works]
		    work.publishers_works(true)
      end
    end
  end
  
  def save_libraries(work)
    LibrariesWork.without_locking do
      LibrariesWork.without_revision do
        logger.debug "Saving libraries_works from session..."
        session[:libraries_works].each do |lw|
          logger.debug "Saving libraries_work: #{lw.inspect}."
          lw.save
        end
        work.libraries_works = session[:libraries_works]
		    work.libraries_works(true)
      end
    end
  end

  def save_composers(work)
    ComposersWork.without_locking do
      ComposersWork.without_revision do
        logger.debug "Saving composers_works from session..."
        session[:composers_works].each do |pw|
          logger.debug "Saving composers_work: #{pw.inspect}."
          pw.save
        end
        work.composers_works = session[:composers_works]
        work.composers_works(true)
      end
    end
  end  

  def save_instrumentations(work)
    InstrumentationsWork.without_locking do
      InstrumentationsWork.without_revision do
        logger.debug "Saving instrumentations_works from session..."
        session[:instrumentations_works].each do |iw|
          logger.debug "Saving instrumentations_work: #{iw.inspect}."
          iw.save
        end
        work.instrumentations_works = session[:instrumentations_works]
		    work.instrumentations_works(true)
      end
    end
  end

  def save_instruments(work)
    logger.debug "Saving instruments_works from session..."
    session[:instruments_works].each do |iw|
      logger.debug "Saving instruments_work: #{iw.inspect}."
      iw.save
    end
    work.instruments_works = session[:instruments_works]
    work.instruments_works(true)
  end

  def save_work_relations(work)
    logger.debug "Saving work_relations from session..."
    session[:work_relations].each do |rw|
      logger.debug "Saving related work: #{rw.inspect}."
      rw.save
    end
    work.work_relations = session[:work_relations]
	  work.work_relations(true)
  end

  def save_quotations(work)
    logger.debug "Saving quotations_works from session..."
    session[:quotations_works].each do |qw|
      logger.debug "Saving related work: #{qw.inspect}."
      qw.save
    end
    work.quotations_works = session[:quotations_works]
	  work.quotations_works(true)
  end

  def save_downloads(work)
    logger.debug "Saving downloads from session..."
    session[:downloads].each do |d|
      logger.debug "Saving download: #{d.inspect}."
      d.save
    end
    work.downloads = session[:downloads]
	  work.downloads(true)
  end

  def get_versions
    @versions = []
    @editorial_changes = []
    diff = @work.compare_with_version(@work.version)
    @editorial_changes.push(
      {:diff => diff,
       :updated_at => @work.updated_at,
       :addition => nil}) if !diff.empty?
    @work.versions.reverse.each do |version|
      diff = @work.compare_with_previous version.version
      if (version.version.odd? && !diff.empty?)
        addition = Addition.find version.addition_id if version.addition_id
        comment = VersionComment.find version.version_comment_id if version.version_comment_id 
        @versions.push(
          {:diff => diff,
           :updated_at => version.updated_at,
           :addition => addition,
           :comment => comment,
           :version => version.version})
      elsif (version.version.even? && !diff.empty?)
        @editorial_changes.push(
          {:diff => diff,
           :updated_at => version.updated_at,
           :addition => nil})
      end
    end
  end

end
