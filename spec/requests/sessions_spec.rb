require 'spec_helper'

describe "Login page" do
  before { visit new_session_path }

  it "should link to the registration" do
    page.should have_selector("a[href='#{new_user_path}']")
  end

  it "should have inputs and remember me checkbox" do
    page.should have_selector("form.new_session input[name='session[logname]']")
    page.should have_selector("form.new_session input[name='session[password]']")
    page.should have_selector("form.new_session input[name='session[remember_me]']")
  end
end

describe "Login" do
  let(:user) { FactoryGirl.create(:user) }

  it "should support the remember me feature"

  describe "for existing user with correct data" do
    before { login! user }

    it "should show user name in the navigation"

    it "should show the logout link" do
      page.should have_selector("a[href='#{sessions_path}']")
    end

    it "should support logging out" do
      find("a[href='#{sessions_path}']").click
      not_logged_in!
    end
  end

  describe "for existing user with wrong password" do
    before { user.orig_password = "wrong"; login! user }
  
    it "should show an error message" do
      page.should have_selector("form.new_session p.error")
    end

    it "should show the login page again with user name" do
      not_logged_in!
      current_path.should == sessions_path
      find("form.new_session input#session_logname").value.should == user.logname
    end
  end

  describe "for existing user with missing password" do
    before { user.orig_password = ""; login! user }
  
    it "should show an error message" do
      should_have_error_message :session, :password
    end

    it "should show the login page again with user name" do
      not_logged_in!
      current_path.should == sessions_path
    end
  end

  describe "with missing user name" do
    before { user.logname = ""; login! user }

    it "should show an error message on the user name" do
      should_have_error_message :session, :logname
    end

    it "should show the login page again" do
      not_logged_in!
      current_path.should == sessions_path
    end
  end

  describe "as admin user" do
    let(:admin) { FactoryGirl.create(:admin) }
    before { login! admin }

    it "should redirect to ???"

    it "should show the admin navigation"

  end
  
end
