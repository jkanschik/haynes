module LoginHelper
  
  def login!(user)
    visit login_users_path
    within "form.login" do
      fill_in 'user_logname', with: user.logname
      fill_in 'user_password', with: user.orig_password
      find("input[type='submit']").click
    end
  end
  
  def logged_in!
    (page.has_content?("Logged in as:") || page.has_content?("Administration")).should be_true
    page.should have_selector("a[href='/users/logout']")
  end
  
  def not_logged_in!
    page.should have_no_content("Logged in as:")
    page.should have_selector("a[href='/users/login']")
  end
  
  def translated!
    page.should have_no_selector(".translation_missing")
    page.should have_no_content("translation missing")
  end

end