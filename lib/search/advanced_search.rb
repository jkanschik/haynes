class AdvancedSearch < Search
  def initialize(params = {})
    super params
    set_order "composers.full_name", "asc"
  end
  def record_class_name
    "Work"
  end
  def view
    "simple"
  end

  def normalise_conditions(params)
    norm_cond = {}
    norm_cond[:"works.here"] = convert_param params[:here]
    norm_cond[:"works.done"] = convert_param_array params[:done]
    norm_cond[:"works.state"] = convert_param_array(params[:state]) || ["default"]
    norm_cond[:attr_doubtful] = convert_param_array params[:attr_doubtful]
    norm_cond[:lost] = convert_param_array params[:lost]
    norm_cond[:tune] = convert_param_like params[:keys]
    norm_cond[:opus] = convert_param_like params[:opus]
    norm_cond[:mod_edition] = convert_param params[:mod_edition]
    norm_cond[:download] = convert_param params[:download]
    norm_cond[:signature] = convert_param_like params[:signature]
    norm_cond[:intern_info_peter] = convert_param_like params[:keywords]
    norm_cond[:composer_id] = convert_param_array params[:composer_id]
    norm_cond[:library_id] = convert_param_array params[:library_id]
    norm_cond[:publisher_id] = convert_param_array params[:publisher_id]
    norm_cond[:instrumentation_id] = convert_param_array(params[:instrumentation_id])
    if params[:country]
        norm_cond[:country] = ""
        Work::COUNTRIES.each do |country|
          norm_cond[:country] += params[:country].include?(country) ? 'Y' : '_'
        end
    end
    if params[:oboe]
        norm_cond[:oboe] = ""
        Work::OBOES.each do |oboe|
          norm_cond[:oboe] += params[:oboe].include?(oboe) ? 'Y' : '_'
        end
    end
    norm_cond[:rism] = "#{convert_param(params[:rism_1]) or '%'}.#{convert_param(params[:rism_2]) or '%'}.#{convert_param(params[:rism_3]) or '%'}"
    norm_cond.delete :rism if norm_cond[:rism] == "%.%.%"
    

    # remove nils
    norm_cond.delete_if {|key, value| value.nil?}
    return norm_cond
  end

  def default_order
    "composers.name, composers.first_name, instrumentation_id, works.title, works.opus, works.tune"
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
    
    ar_cond = [" true "]
    include = [:composer, :instrumentations, :composers_works]
    if cond[:composer_id]
      ar_cond[0] += " and (works.composer_id in (?) or composers_works.composer_id in (?))"
      ar_cond.push cond[:composer_id]
      ar_cond.push cond[:composer_id]
    end
    if cond[:instrumentation_id]
      ar_cond[0] += " and instrumentation_id in (?) "
      ar_cond.push unpack_instrumentations(cond[:instrumentation_id])
    end
    if cond[:library_id]
      include.push :libraries
      ar_cond[0] += " and library_id in (?) "
      ar_cond.push cond[:library_id]
    end
    if cond[:publisher_id]
      include.push :publishers
      ar_cond[0] += " and publisher_id in (?) "
      ar_cond.push cond[:publisher_id]
    end
    if cond[:mod_edition]
      include.push :publishers
      ar_cond[0] += " and publisher_id is #{'not' if cond[:mod_edition] == 'Y'} null "
    end
    if cond[:download]
      include.push :downloads
      ar_cond[0] += " and downloads.id is #{'not' if cond[:download] == 'Y'} null "
    end
    if cond[:rism]
      include.push :quotations_works
      ar_cond[0] += " and quotations_works.comment like _utf8 ? COLLATE utf8_bin "
      ar_cond.push cond[:rism]
    end
    if cond[:signature]
      include.push :libraries_works
      ar_cond[0] += " and libraries_works.comment like _utf8 ? COLLATE utf8_bin "
      ar_cond.push cond[:signature]
    end
    if cond[:tune]
      tune = cond[:tune].gsub(/[^a-gA-G#\ ]/,"")
      tune.gsub!(/#/, "S")
      ar_cond[0] += " and replace(tune, '#', 'S') regexp binary '[[:<:]]#{tune}[[:>:]]' "
    end
    ["works.done", "lost", "attr_doubtful", "works.state", "works.here"].each do |field|
      c = cond[field.to_sym]
      if c
          ar_cond[0] += " and #{field}" +  (c.class == Array ? " in (?) " : " = ? ")
          ar_cond.push c
      end
    end
    ["country", "oboe", "opus"].each do |field|
        if cond[field.to_sym]
          ar_cond[0] += " and #{field} like _utf8 ? COLLATE utf8_bin "
          ar_cond.push cond[field.to_sym]
        end
    end
    if cond[:intern_info_peter]
      ar_cond[0] += " and (" + 
         "intern_info_peter like _utf8 ? COLLATE utf8_bin or " + 
         "intern_info_bruce like _utf8 ? COLLATE utf8_bin or " + 
         "works.misc_info like _utf8 ? COLLATE utf8_bin) "
      ar_cond.push cond[:intern_info_peter]
      ar_cond.push cond[:intern_info_peter]
      ar_cond.push cond[:intern_info_peter]
    end
	
	
	
    Rails.logger.debug "Search '#{name}' : Conditions for ActiveRecord are #{ar_cond.inspect}."
    if ar_cond[0] != "" 
      @cache = Work.find(
        :all,
        :select => "id",
        :include => include,
        :order => ar_order,
        :conditions => ar_cond
      ).collect {|w| w.id}
    else
      @cache = Work.find(
        :all,
        :select => "id",
        :include => include,
        :order => ar_order
      ).collect {|w| w.id}
    end
  end


end
