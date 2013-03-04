class ProblemsSearch < Search
  def record_class_name
    "Problem"
  end
  
  def normalise_conditions(params)
    return {}
  end

  def default_order
    "problems.category, problems.title"
  end

  def init_cache
    if @cache
    Rails.logger.info "Search '#{name}' : Cache already initialised."
    return
    end
    Rails.logger.info "Search '#{name}' : Cache not initialised, start with db access."
    Rails.logger.info "Search '#{name}' : Conditions are #{conditions}"

    cond = conditions
    ar_cond = " true "
    ar_cond += " and done = :done " if cond[:done]
    ar_cond += " and active = :active " if cond[:active]

    @cache = Problem.find(
      :all,
      :select => "id",
      :order => ar_order
    ).collect {|w| w.id}
  end

end
