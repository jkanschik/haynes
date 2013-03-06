module LoginHelper
  
  def login!(user)
    visit new_session_path
    within "form.new_session" do
      fill_in 'session_logname', with: user.logname
      fill_in 'session_password', with: user.orig_password
      find("input[type='submit']").click
    end
  end
  
  def logged_in!
    (page.has_content?("Logged in as:") || page.has_content?("Administration")).should be_true
    page.should have_selector("a[href='#{sessions_path}']")
  end
  
  def not_logged_in!
    page.should have_no_content("Logged in as:")
    page.should have_selector("a[href='#{new_session_path}']")
  end
  
  def translated!
    page.should have_no_selector(".translation_missing")
    page.should have_no_content("translation missing")
  end

  def should_have_error_message(object_name, field)
    object_name = object_name.to_s
    field = field.to_s
    page.should have_selector("form.new_#{object_name} div.field_with_errors input##{object_name}_#{field}")
    page.should have_selector("form.new_#{object_name} div p.error")
  end

end