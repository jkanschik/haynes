require 'spec_helper'

describe "Registration" do

  before { visit register_users_path }

  def shows_registration_form
    within "form.login" do
      page.should have_selector("input#user_name")
      page.should have_selector("input#user_logname")
      page.should have_selector("input#user_mail")
      page.should have_selector("input#user_orig_password[type='password']")
      page.should have_selector("input#user_orig_password_confirmation[type='password']")
    end
  end
  
  it "should show the form if directly called" do
    visit register_users_path
    shows_registration_form
  end

  it "should show the form if using link from login page" do
    visit login_users_path
    find("a[href='#{register_users_path}']").click
    shows_registration_form
  end

    describe "if correct user data is provided" do
      before do
        User.count.should == 0
        @user = FactoryGirl.build(:user)
        within "form.login" do
          fill_in :user_name, with: @user.name
          fill_in :user_logname, with: @user.logname
          fill_in :user_orig_password, with: @user.orig_password
          fill_in :user_orig_password_confirmation, with: @user.orig_password
          find("input[type='submit']").click
        end
      end
    
      it "should create a new user on submit" do
        User.count.should == 1
      end
      
      it "should redirect to the login" do
        current_path.should == login_users_path
      end
      
      it "should default the login name to the logname of the user" do
        find("form.login input#user_logname").value.should == @user.logname
      end
    end

  it "should fail if no user name is given" do
    user = FactoryGirl.build(:user)
    within "form.login" do
      fill_in :user_mail, with: user.mail
      fill_in :user_orig_password, with: user.orig_password
      find("input[type='submit']").click
      current_path.should == register_users_path
    end
  end
end

describe "login" do
  let(:user) { FactoryGirl.create(:user) }
  
  it "should log in a normal user" do
    login! user
    logged_in!
    find("a[href='/users/logout']").click
    not_logged_in!
  end
  
  it "should should a message if password is wrong" do
    user.orig_password = "wrong"
    login! user
    not_logged_in!
    current_path.should == login_users_path
    page.should have_selector("form.login p.error")
    page.should have_selector("input#user_logname.error")
    page.should have_selector("input#user_password.error")
  end
  
  it "should should a message if password is missing" do
    user.orig_password = ""
    login! user
    not_logged_in!
    current_path.should == login_users_path
    page.should have_no_selector("input#user_logname.error")
    page.should have_selector("input#user_password.error")
  end

  it "should should a message if user name is missing" do
    user.logname = ""
    login! user
    not_logged_in!
    current_path.should == login_users_path
    page.should have_selector("input#user_logname.error")
    page.should have_no_selector("input#user_password.error")
  end
  
  let(:admin) { FactoryGirl.create(:admin) }

  it "should log in an admin user" do
    login! admin
    logged_in!
    find("a[href='/users/logout']").click
    not_logged_in!
  end
end
