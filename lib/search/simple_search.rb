class SimpleSearch < Search
  def initialize(params = {})
    super params
    set_order "composers.full_name", "asc"
  end
  def record_class_name
    "Work"
  end
  
  def normalise_conditions(params)
    norm_cond = {}
    norm_cond[:composer_id] = convert_param_array params[:composer_id]
    norm_cond[:library_id] = convert_param_array params[:library_id]
    norm_cond[:instrumentation_id] = convert_param_array params[:instrumentation_id]
    
    # remove nils
    norm_cond.delete_if {|key, value| value.nil?}
    return norm_cond
  end

  def default_order
    "composers.name, composers.first_name, lpad(instrumentations.code, 5, '0'), title, opus, tune"
  end


  def init_cache
    if @cache
      Rails.logger.info "Search '#{name}' : Cache already initialised."
      return
    end
    Rails.logger.info "Search '#{name}' : Cache not initialised, start with db access."
    Rails.logger.debug "Search '#{name}' : Conditions are #{conditions.inspect}"
    # derive correct AR conditions
    cond = conditions
    
    ar_cond = [" works.state = 'default' "]
    include = [:composer, :instrumentations, :composers_works]
    if cond[:composer_id]
      ar_cond[0] += " and (works.composer_id in (?) or composers_works.composer_id in (?))"
      ar_cond.push cond[:composer_id]
      ar_cond.push cond[:composer_id]
    end
    if cond[:instrumentation_id]
      ar_cond[0] += " and instrumentations.id in (?)"
      ar_cond.push unpack_instrumentations(cond[:instrumentation_id])
    end
    
    Rails.logger.debug "Search '#{name}' : Conditions for ActiveRecord are #{ar_cond.inspect}."
    @cache = Work.find(
      :all,
      :select => "id",
      :include => include,
      :order => ar_order,
      :conditions => ar_cond
    ).collect {|w| w.id}
  end


end
