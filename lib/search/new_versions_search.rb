class NewVersionsSearch < Search
  def initialize(params = {})
    super params
    set_order "work_versions.updated_at", "desc"
  end
  def record_class_name
    "Work"
  end

  def default_order
    "work_versions.updated_at desc, composers.name, composers.first_name, instrumentations.id, works.title, works.opus, works.tune"
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
      :include => [:composer, :instrumentations_works, :instrumentations, :work_versions],
      :conditions => "work_versions.version > 1 and works.state = 'default'",
	    :order => ar_order
	  ).collect {|w| w.id}.uniq
  end


end
