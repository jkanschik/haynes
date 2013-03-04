class MainController < ApplicationController
  NUMBER_OF_EVENTS = 10

  def index
    @libraries = 
      [["any library", ""]] | 
      Library.find(
        :all,
        :select => "code_place, countries.code, id",
        :include => "country",
        :order => "countries.code asc, code_place asc").
        collect {|c| [c.nice_label, c.id]}
    @publishers = 
      [["any publisher", ""]] | 
      Publisher.find(
        :all,
        :select => "label, id",
        :order => "label asc").
        collect {|c| [c.label, c.id]}
    
    get_new_works
    get_versions
    # sort the events:
    @all_events = @versions + @new_works
    @all_events.sort! {|x,y| y[:date] <=> x[:date]}
    @all_events = @all_events[0..NUMBER_OF_EVENTS - 1]
    @event_type = :all
  end
  
  def quick_search_select
    params[:instrumentation_id].gsub!("head", "") if params[:instrumentation_id]
    render :update do |page|
      page.replace_html :instrumentation_id,
        :text => options_for_select(instrumentations(nil, params[:composer_id]), params[:instrumentation_id])
      page.replace_html :composer_id,
        :text => options_for_select(composers(nil, params[:instrumentation_id]), params[:composer_id])
    end
  end

private
  def get_search(name)
    session[:searches].each_value do |search|
      return search if search.class.name == name
    end
    s = ObjectSpace.const_get(name).new
    s.visible = false
    session[:searches].store(s.search_id, s)
    return s
  end

  def get_new_works
    search = get_search "NewEntriesSearch"
    @new_works = []
    page = search.page(1)
    0.upto [NUMBER_OF_EVENTS, page.size].min - 1 do |i|
      work = Work.find page[i]
      @new_works.push({
        :date => work.created_at,
        :work => work,
        :type => :creation,
        :record => i,
        :search_id => search.search_id
      })
    end
  end

  def get_versions
    search = get_search "NewVersionsSearch"
    @versions = []
    page = search.page(1)
    0.upto [NUMBER_OF_EVENTS, page.size].min - 1 do |i|
      work = Work.find page[i]
      @versions.push({
        :date => work.versions.latest.updated_at,
        :work => work,
        :type => :version,
        :record => i,
        :search_id => search.search_id
      })
    end
  end
end
