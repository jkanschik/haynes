require 'spec_helper'

describe "users/new" do
  before(:each) do
    assign(:user, stub_model(User,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new user form" do
    render

    assert_select "form[action=?][method=?]", users_path, "post" do
      assert_select "input#user_name[name=?]", "user[name]"
      assert_select "input#user_logname[name=?]", "user[logname]"
      assert_select "input#user_mail[name=?]", "user[mail]"
      assert_select "input#user_orig_password[name=?]", "user[orig_password]"
      assert_select "input#user_orig_password_confirmation[name=?]", "user[orig_password_confirmation]"
    end

# Copied from default index.html.erb_spec to check that there are 2 records in a table:
#        assert_select "tr>td", :text => "Name".to_s, :count => 2

  end
end
