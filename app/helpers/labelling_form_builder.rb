class LabellingFormBuilder < ActionView::Helpers::FormBuilder
  
  def text_field(method, options = {})
    "<div>#{label(method)}#{super(method, options)}#{error_tag(method)}</div>".html_safe
  end

  def password_field(method, options = {})
    "<div>#{label(method)}#{super(method, options)}#{error_tag(method)}</div>".html_safe
  end

private
  def error_tag(method)
    @object.errors.messages[method].collect { |msg| "<p class='error'>#{msg}</p>"}.join
  end
end