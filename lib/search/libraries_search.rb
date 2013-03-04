class LibrariesSearch < Search
  def record_class_name
    "Library"
  end
  
  def normalise_conditions(params)
    return {}
  end

  def default_order
    "countries.code, libraries.code_place, libraries.name, countries.label, libraries.city"
  end

  def init_cache
    if @cache
      Rails.logger.info "Search '#{name}' : Cache already initialised."
      return
    end
    Rails.logger.info "Search '#{name}' : Cache not initialised, start with db access."
    Rails.logger.info "Search '#{name}' : Conditions are #{conditions}"

    cond = conditions
    ar_cond = " state <> 'drop' "
    ar_cond += " and done = :done " if cond[:done]
    ar_cond += " and active = :active " if cond[:active]

    @cache = Library.find(
      :all,
      :select => "id",
      :order => ar_order,
      :include => [:country],
      :conditions => [ar_cond, {:done => cond[:done], :active => cond[:active]}]
    ).collect {|w| w.id}
  end

end
