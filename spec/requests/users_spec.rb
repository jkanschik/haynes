require 'spec_helper'

describe "Registration" do

  before { visit new_user_path }

  def fill_user_form(user)
    within "form.new_user" do
      fill_in :user_name, with: user.name
      fill_in :user_logname, with: user.logname
      fill_in :user_orig_password, with: user.orig_password
      fill_in :user_orig_password_confirmation, with: user.orig_password
      find("input[type='submit']").click
    end
  end
  
  context "if correct user data is provided" do
    let(:user) { FactoryGirl.build(:user) }

    before do
      User.count.should == 0
      fill_user_form user
    end
  
    it "should create a new user on submit" do
      User.count.should == 1
    end
    
    it "should redirect to the login" do
      current_path.should == new_session_path
    end
    
    it "should default the login name to the logname of the user" do
      find("form.new_session input#session_logname").value.should == user.logname
    end
  end

  it "should fail if no user name is given" do
    user = FactoryGirl.build(:user, logname: "")
    fill_user_form user
    current_path.should == users_path
    should_have_error_message :user, :logname
  end
end
