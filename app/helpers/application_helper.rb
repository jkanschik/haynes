module ApplicationHelper

	def composers(length = nil, instrumentation_id = nil)
	  instr_ids = nil
    if instrumentation_id and instrumentation_id != ""
      instr_ids = !Instrumentation.find(instrumentation_id).children.empty? ? Instrumentation.find(instrumentation_id).children.collect {|c| c.id} : [instrumentation_id]
    end
    
    sql = <<-EOSQL

      -- normal composers
      select
        composers.first_name first_name,
        composers.name name,
        composers.id id
      from
        composers
        join works on works.composer_id = composers.id and works.state = 'default'
        #{'join instrumentations_works on works.id = instrumentations_works.work_id and instrumentations_works.instrumentation_id in (?)' if instr_ids}
      where
        composers.state = 'default'

      union

      -- alias of normal composers
      select
        composers.first_name first_name,
        alias.name name,
        composers.id id
      from
        alias
        join composers on alias.composer_id = composers.id
        join works on works.composer_id = composers.id and works.state = 'default'
        #{'join instrumentations_works on works.id = instrumentations_works.work_id and instrumentations_works.instrumentation_id in (?)' if instr_ids}
      where
        composers.state = 'default'

      union

      -- alternative composers
      select
        composers.first_name first_name,
        composers.name name,
        composers.id id
      from
        composers
        join composers_works on composers.id = composers_works.composer_id
        join works on works.id = composers_works.work_id and works.state = 'default'
        #{'join instrumentations_works on works.id = instrumentations_works.work_id and instrumentations_works.instrumentation_id in (?)' if instr_ids}
      where
        composers.state = 'default'

      union

      -- alias of alternative composers
      select
        composers.first_name first_name,
        alias.name name,
        composers.id id
      from
        alias
        join composers on alias.composer_id = composers.id
        join composers_works on composers.id = composers_works.composer_id
        join works on works.id = composers_works.work_id and works.state = 'default'
        #{'join instrumentations_works on works.id = instrumentations_works.work_id and instrumentations_works.instrumentation_id in (?)' if instr_ids}
      where
        composers.state = 'default'

      order by
        name asc,
        first_name asc
    EOSQL

    sql = [sql, instr_ids, instr_ids, instr_ids, instr_ids] if instr_ids

    list = Composer.find_by_sql sql
    list = [["any composer", ""]] | list.
		  collect {|c| [c.full_name, c.id.to_s]}

		return length ? list.collect {|a| [truncate(a[0], :length => length), a[1]]} : list
  end

  def instrumentations(length = nil, composer_id = nil)
    composer_cond = (composer_id and composer_id != "") ? " and composer_id = ? " : ""
    sql = <<-EOSQL
      select
        id, label, code, parent_id
      from 
        instrumentations
      where
        #{'parent_id is null or' if composer_cond == ""}  
        id in (
          select
            instrumentations_works.instrumentation_id
          from
            instrumentations_works join works on instrumentations_works.work_id = works.id
          where state = 'default' #{composer_cond})
      order by substr('00000' || code, -5, 5) -- lpad(code, 5, '0')
      EOSQL
    sql = [sql, composer_id] if composer_cond != ""
    list = Instrumentation.find_by_sql sql
    list = [["any category", ""]] |	list.
			collect {|i| [i.code + ". " + i.label, i.id.to_s + (i.parent_id ? "" : "head")]}
		length ? list.collect {|a| [truncate(a[0], :length => length), a[1]]} : list
	end
  
  def search_pager(search)
    html = "<p class='commands'>"
    if !search.first_record?
      html +=
        link_to '|&laquo;',
        { :controller => '/search',
          :action => 'first',
          :id => search.search_id
        }
      html += " "
      html +=
        link_to '<',
        { :controller => '/search',
          :action => 'previous',
          :id => search.search_id
        }
    end
    html += " #{search.record_index + 1} of #{search.number_of_records} "
    if !search.last_record?
      html += link_to '>',
        { :controller => '/search',
          :action => 'next',
          :id => search.search_id
        }
      html += " "
      html += link_to '&raquo;|',
        { :controller => '/search',
          :action => 'last',
          :id => search.search_id
        }
    end
    html += "</p>"
    return html
  end
  
  
  def admin?
    logged_in?# and current_user.role =='admin'
  end
  
  def anti_spam_mail_to(mail, text)
    if logged_in?
      return mail_to(mail, text)
    else
      return "<span title='Please login to see the mail address.'>#{text}</span>".html_safe
    end  
  end


  def table_header(search, name, title, column, options = {})
  	next_order = search.next_order(column)
    case next_order
    when 'asc'
      tooltip = title + ' (click to sort ascending)'
    when 'desc'
      tooltip = title + ' (click to sort descending)'
    end
    if search.column == column
	  klazz = search.order
    end	
    order_options = {}
    order_options = {:column => column, :order => next_order} if next_order
    return link_to(name, options.merge(order_options), :title => tooltip, :class => klazz)
  end



  def pager(search)
    return if search.number_of_pages == 1
    html = ""
    html += link_to('|&laquo;', :page => 1) if search.page_number > 1
    html += link_to('<', :page => search.page_number - 1) if search.page_number > 1
    html += " page #{search.page_number} of #{search.number_of_pages} "
    html += link_to('>', :page => search.page_number + 1) if search.page_number < search.number_of_pages 
    html += link_to('&raquo;|', :page => search.number_of_pages) if search.page_number < search.number_of_pages

    html += " Change page size to : "
    options = {:controller => :search, :action => :set_page_size, :id => search.search_id}
    html += search.records_per_page == 10 ? "10 ; " : link_to('10', options.merge({:size => "10"})) + " ; "
    html += search.records_per_page == 25 ? "25 ; " : link_to('25', options.merge({:size => "25"})) + " ; "
    html += search.records_per_page == 50 ? "50 ; " : link_to('50', options.merge({:size => "50"})) + " ; "
    html += search.records_per_page == 100 ? "100" : link_to('100', options.merge({:size => "100"}))

    return html
  end

  def text_field_tag_error(name, value = nil, options = {})
    if flash[name.to_sym]
      options[:class] = options[:class] ? options[:class] + " error" : "error"
      return text_field_tag(name, value, options) + error_msg(name)
    end
    return text_field_tag(name, value, options)
  end


  def error_msg(name)
    return "" unless @errors && @errors[name.to_sym] or flash[name.to_sym]
    html = ""
	if @errors and @errors[name.to_sym]
   	    @errors[name.to_sym].each do |error|
            html += "<span class='error'>" + error + "</span>"
        end
	end
	flash[name.to_sym].each do |error|
            html += "<span class='error'>" + error + "</span>"
    end
    return html
  end

  
  def labelled_text_field(label, object_name, field, options = {})
    object = @template.instance_variable_get("@#{object_name}")
	errors = object ? (object.errors.on(field) or []) : []
    errors = errors | @errors[field] if (@errors and @errors[field])
    options[:class] = options[:class] ? options[:class] + " error" : "error" if errors.size > 0
    html = <<-EOHTML
	   <div>
        <label for="#{field}">#{label}</label>
        #{text_field(object_name, field, options)}
    EOHTML
    errors.each do |error|
        html += "<p class='error'>" + error + "</p>"
    end

    return (html + "</div>").html_safe
  end

  def labelled_password_field(label, object_name, field, options = {})
    object = @template.instance_variable_get("@#{object_name}")
    errors = object ? (object.errors.on(field) or []) : []
    errors |= @errors[field] if @errors and @errors[field]
    options[:class] = options[:class] ? options[:class] + " error" : "error" if errors.size > 0
    html = <<-EOHTML
	   <div>
        <label for="#{field}">#{label}</label>
        #{password_field(object_name, field, options)}
    EOHTML
    (errors or []).each do |error|
        html += "<p class='error'>" + error + "</p>"
    end

    return (html + "</div>").html_safe
  end
  
  
  
  
  
  
  def labelled_select(label, name, container, options = {}, html_options = {})
    error_msg = error_msg(name)
    if error_msg != ""
      html_options[:class] = html_options[:class] ? html_options[:class] + " error" : "error"
    end
    html = <<-EOHTML
      <div class="required">
        <label for="#{name}">#{label}</label>
        #{select('work', name, container, options, html_options)}
        #{error_msg}
      </div>
    EOHTML
    return html.html_safe
  end


  def labelled_check_box(label, name, value, checked, options = {})
    error_msg = error_msg(name)
    if error_msg != ""
      options[:class] = options[:class] ? options[:class] + " error" : "error"
    end
    html = <<-EOHTML
      <div class="required">
        <label for="#{name}">#{label}</label>
        #{check_box_tag(name, value, checked, options)}
        #{error_msg}
      </div>
    EOHTML
    return html.html_safe
  end



  
  
  def labelled_text(label, content, position = 0)
    text = <<-EOHTML
      <div class="column" style='margin-left: -#{100-position}%'>
        <p class="label">#{label}</p>
        <p class="content">#{hyphenate content}</p>
      </div>
    EOHTML
    text.html_safe
  end

  def hyphenate(text = nil)
    return "---" if text.nil? || text == "" || text == "NULL"
    return text
  end
  
  def code_select(context)
    Code.by_context(context).all.collect {|code| [code.label, code.code]}
  end

  def code_label(c, context)
#    code = Code.find_by_code_and_context c, context # exact match => done
#    code = Code.find :first, :conditions => ["code = ? and locate(context, ?) = 1", c, context] unless code
    code = Code.by_code_and_context(c, context).first
    return "?" unless code
    "<span style='#{code.style}'>#{code.label}</span>".html_safe
  end
  
  def mail_address()
    return "mailto:info@haynes-catalog.net"
  end

  def incipit(work)
    pdf = File.dirname(__FILE__) + "/../../public/incipits/incipit_#{work.id}.pdf"
    logger.debug "PDF file is expected at: #{pdf}"
    # if there is no incipit at all, we are done
    return "" if not File.exists?(pdf)
    return link_to(image_tag("pdficon_small.gif", :border => 0),
      "/incipits/incipit_#{work.id}.pdf",
      :popup => [CGI::escape("Incipit for #{work.title}")])
  end

  def incipit_full_record_old(work)
    pdf = File.dirname(__FILE__) + "/../../public/incipits/incipit_#{work.id}.pdf"
    logger.debug "PDF file is expected at: #{pdf}"
    # if there is no incipit at all, we are done
    return "Show Incipit" if not File.exists?(pdf)
    return link_to(image_tag("Show Incipit", :border => 0),
      "/incipits/incipit_#{work.id}.pdf",
      :popup => [CGI::escape("Incipit for #{work.title}")])
  end
  
 def incipit_full_record(work)
    pdf = File.dirname(__FILE__) + "/../../public/incipits/incipit_#{work.id}.pdf"
    logger.debug "PDF file is expected at: #{pdf}"
    # if there is no incipit at all, we are done
    return "Show Incipit" if not File.exists?(pdf)
    return link_to("Show Incipit", 
      "/incipits/incipit_#{work.id}.pdf",
      :popup => [CGI::escape("Incipit for #{work.title}")])
  end

  def help(view)
    ("(" + 
      link_to("Help", 
        {:controller => 'help', :action => view},
        :title => "Click for help",
        :onclick => "window.open(this.href,'Help','height=200,width=400');return false;") +
    ")").html_safe
  end

end
