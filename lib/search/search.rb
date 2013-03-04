class Search
  
  attr_accessor :visible
  attr_accessor :search_id
  attr_accessor :page_number
  attr_accessor :record_index
  attr_accessor :records_per_page
  attr_reader   :column, :order, :conditions, :created_at

  def initialize(params = {})
    Rails.logger.info "Search '#{name}' : Initializing with params = #{params.inspect}."
    @conditions = normalise_conditions params
    @page_number = 1
    @records_per_page = 25
    @search_id = object_id.to_s # object id will change when session is restored from session store.
  	@created_at = Time.now
    @visible = true
    Rails.logger.debug "Search '#{name}' : Initialized with conditions #{conditions.inspect}."
  end
  
  def normalise_conditions(params)
    {}
  end

  def name
  	self.class.to_s[0, self.class.to_s.length - "search".length].underscore
  end
  
  def summary_name
  	"summary_" + name
  end
  def controller
    record_class_name.pluralize
  end
  def set_order(column, order)
    if [@column, @order] != [column, order]
      Rails.logger.debug "Search '#{name}' : Order changed from '#{@column} #{@order}' to '#{column} #{order}'."
 	  refresh
	  @page_number = 1
    end
    @column, @order = column, order
  end

  def refresh
    @cache = nil
    @record_index = nil
  end

  def ar_order
    if @column && @order
      # special cases
      case @column
        when "composers.full_name"
          return "composers.name #{order}, composers.first_name #{order}, " + default_order
        when "libraries.code"
          return "countries.code #{order}, libraries.code_place #{order}, " + default_order
        when "instrumentations.code"
          return "lpad(instrumentations.code, 5, '0') #{order}, " + default_order
      end
      # usual order
      return "#{@column} #{@order}, " + default_order
    end
    # default if no column/order is given
    return default_order
  end

  # Bestimmt die Sortierreihenfolge, die genommen wird, wenn der Benutzer auf diese Spalte klickt.
  # Beispiel:
  #   Es wurde nach Composer aufsteigend sortiert (@column = composer, @order = asc). 
  #   Dann gibt next_order "desc" zurück, weil beim nächsten mal absteigend sortiert werden muss.
  def next_order(column)
    if @column == column
      return "desc" if @order == "asc"
      return "asc" if @order == "desc"
    end
    return "asc"
  end

  def page(number = nil)
    number ||= @page_number
    Rails.logger.debug "Search '#{name}' : page called, for page = #{number}."
    init_cache
    first = records_per_page * (number - 1)
    @cache[first, records_per_page] || []
  end

  def records
    init_cache
    @cache
  end
  
  def number_of_pages
    return (number_of_records - 1) / records_per_page + 1
  end

  def number_of_records
    init_cache unless @cache
    return @cache.size
  end

  def page_number
    @page_number = 1 if @page_number < 1
    @page_number = number_of_pages if @page_number > number_of_pages
    return @page_number
  end

  def records_per_page
    @records_per_page || 25
  end
  def records_per_page=(new_value)
    @records_per_page = new_value
  end
  
  def first_record?
    return @record_index == 0
  end
  
  def last_record?
    return @record_index == number_of_records - 1
  end

  def record
    return nil unless @record_index
    init_cache
    @cache[@record_index]
  end

  def clear_cache
    @cache = nil
  end

  def view
    name
  end
  
  def <=>(other)
  	created_at <=> other.created_at
  end
protected

  def convert_param(param)
    return nil if param == nil or param == ""
    return param
  end

  def convert_param_like(param)
    return nil if param == nil or param == ""
    return "%#{param}%"
  end

  def convert_param_array(params)
    return unless params
    converted_params = params.collect{|p| (p =~ /\d/) == 0 ? p.to_i : p unless p == ""}.compact
    converted_params == [] ? nil : converted_params
  end

  def unpack_instrumentations(instr)
    return nil unless instr
    ret = instr.dup
    ret.each do |i|
      Instrumentation.find(i).children.each {|child| ret << child.id}
    end
  end
end