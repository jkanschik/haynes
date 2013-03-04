require 'spec_helper'

def fill_in_publisher_form(publisher)
  within "form[class$='_publisher']" do
    fill_in :publisher_label, with: publisher.label
    fill_in :publisher_name, with: publisher.name
    find("input[type='submit']").click
  end
  translated!
end

describe "Publisher" do
  let(:publisher) { FactoryGirl.create(:publisher) }

  describe "showing publisher" do
    it "should show the label" do
      visit publisher_path publisher
      not_logged_in!
      page.should have_content(publisher.label)
    end
  end

  describe "administration without login" do
    it "should not allow access to publisher paths" do
      [admin_publisher_path(publisher), new_admin_publisher_path].each do |path|
        visit path
        not_logged_in!
        current_path.should == root_path
      end
    end
  end

  describe "administration with login as admin" do
    before { login! FactoryGirl.create :admin }

    it "should show a publisher (GET show)" do
      visit admin_publisher_path publisher
      logged_in!
      translated!
      page.should have_content(publisher.label)
    end

    it "should show the form for a new publisher (GET new)" do
      visit new_admin_publisher_path
      logged_in!
      translated!
      page.should have_selector("input#publisher_label")
    end

    describe "creation of a new publisher" do
      before { visit new_admin_publisher_path }

      it "should create a new publisher" do
        new_publisher = FactoryGirl.build(:publisher)
        new_publisher.label += " new"

        Publisher.count.should == 0
        fill_in_publisher_form(new_publisher)
        Publisher.count.should == 1
        
        new_publisher_db = Publisher.find_by_label new_publisher.label
        current_path.should == admin_publisher_path(new_publisher_db)
        page.should have_content(new_publisher_db.label)
      end

      it "should show validation errors for a new publisher" do
        fill_in_publisher_form(publisher)
        current_path.should == admin_publishers_path
        page.should have_selector("div.errors")
      end
    end
  end
  
end
