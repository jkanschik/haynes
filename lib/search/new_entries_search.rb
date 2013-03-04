class NewEntriesSearch < Search
  def initialize(params = {})
    super params
    set_order "works.created_at", "desc"
  end
  def record_class_name
    "Work"
  end

  def default_order
    "works.created_at desc, composers.name, composers.first_name, instrumentations.code, title, opus, tune"
  end


  def init_cache
    if @cache
      Rails.logger.info "Search '#{name}' : Cache already initialised."
      return
    end
    Rails.logger.info "Search '#{name}' : Cache not initialised, start with db access."
    Rails.logger.debug "Search '#{name}' : Conditions are #{conditions}"
	  @cache = Work.find(
	    :all,
	    :select => "id",
      :include => [:composer,:instrumentations_works, :instrumentations],
      :conditions => "source_id > 1 and works.state = 'default'",
	    :order => ar_order
	  ).collect {|w| w.id}
  end


end
