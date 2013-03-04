class QuotationsSearch < Search
  def record_class_name
    "Quotation"
  end
  
  def normalise_conditions(params)
    return {}
  end

  def default_order
    "quotations.author, quotations.title, quotations.article"
  end

  def controller
    "References"
  end

  def init_cache
    if @cache
      Rails.logger.info "Search '#{name}' : Cache already initialised."
      return
    end
    Rails.logger.info "Search '#{name}' : Cache not initialised, start with db access."
    Rails.logger.info "Search '#{name}' : Conditions are #{conditions}"

    @cache = Quotation.find(
      :all,
      :select => "id",
      :order => ar_order
    ).collect {|w| w.id}
  end

  
end