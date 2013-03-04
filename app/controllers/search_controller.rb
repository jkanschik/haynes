class SearchController < ApplicationController
  layout "layouts/application" ,  :except => :export

  def advanced
	  @libraries = 
		[["any library", ""]] | 
		Library.find(
		  :all,
		  :select => "code_place, countries.code, id",
		  :include => "country",
      :conditions => "state <> 'drop'",
		  :order => "countries.code asc, code_place asc").
		  collect {|c| [c.nice_label, c.id]}
	  @publishers = 
		[["any publisher", ""]] | 
		Publisher.find(
		  :all,
		  :select => "label, id",
      :conditions => "state <> 'drop'",
		  :order => "label asc").
		  collect {|c| [c.label, c.id]}
  end
  
  def search
    logger.debug "SearchController.search invoked, starting search with name #{params[:name]}."
#    begin
      s = ObjectSpace.const_get(params[:name] + "Search").new params
#    rescue Exception => e
#      logger.info "Redirect to home because of exception #{e}"
#      redirect_to :controller => 'main', :action => 'index'
#      return
#    end
    session[:searches].store(s.search_id, s)
    if params[:record]
      redirect_to :action => :show, :id => s.search_id, :record => params[:record]
    else
      redirect_to :action => 'list', :id => s.search_id
    end
  end
  
  def list
    @search = get_search
    return unless @search
    @search.visible = true
    if params[:page]
      @search.page_number = params[:page].to_i
      @search.record_index = nil
    elsif @search.record_index
      @search.page_number = 1 + @search.record_index / @search.records_per_page
    end
    if params[:column] and params[:order]
      @search.set_order params[:column], params[:order]
    end
    @page = @search.page
    render :action => "list_#{@search.view}"
  end
  
  def refresh
    logger.debug "SearchController.refresh invoked for search #{params[:id]}."
    return unless get_search
    get_search.refresh
    redirect_to :action => 'list', :id => params[:id]
  end

  def show
    logger.debug "SearchController.show invoked for search #{params[:id]}."
    s = get_search
    return unless s
    s.record_index = params[:record].to_i
    redirect_to_record s
  end
  def next
    logger.debug "SearchController.next invoked for search #{params[:id]}."
    s = get_search
    return unless s
    s.record_index += 1 if s.record_index < s.number_of_records - 1
    redirect_to_record s
  end
  def last
    logger.debug "SearchController.last invoked for search #{params[:id]}."
    s = get_search
    return unless s
    s.record_index = s.number_of_records - 1
    redirect_to_record s
  end
  def previous
    logger.debug "SearchController.previous invoked for search #{params[:id]}."
    s = get_search
    return unless s
    s.record_index -= 1 if s.record_index > 0
    redirect_to_record s
  end
  def first
    logger.debug "SearchController.first invoked for search #{params[:id]}."
    s = get_search
    return unless s
    s.record_index = 0
    redirect_to_record s
  end

  def set_page_size
    logger.debug "SearchController.set_page_size invoked for search #{params[:id]}."
    s = get_search
    return unless s
    s.page_number = 1 + ((s.page_number - 1) * s.records_per_page) / params[:size].to_i
    s.records_per_page = params[:size].to_i
    redirect_to :action => :list, :id => s.search_id
  end

  def change_to_done
    logger.debug "SearchController.change_to_done invoked for search #{params[:id]}."
    s = get_search
    return unless s
    if (s.record_class_name == "Work")
      Work.update_all("done = 'N'", ["id in (?)", s.records])
    end    
    redirect_to :action => :list, :id => s.search_id
  end
  
private 
  def redirect_to_record(search)
    controller = admin? ? "admin/" : ""
    controller += search.controller
    redirect_to :controller => controller, :action => (params[:next_action] or 'show'),
                :id => search.record, :search_id => search.search_id
  end

  def get_search(id = nil)
    s = session[:searches][id || params[:id]]
    return s if s
    redirect_to :controller => 'main', :action => 'index'
    return nil
  end
end





