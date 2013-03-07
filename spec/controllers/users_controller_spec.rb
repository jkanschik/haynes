require 'spec_helper'

describe UsersController do

  describe "GET new" do
    it "assigns a new user as @user" do
      get :new
      assigns(:user).should be_a_new(User)
      expect(response).to render_template("new")
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new User" do
        expect {
          post :create, {:user => FactoryGirl.attributes_for(:user)}
        }.to change(User, :count).by(1)
      end
    end

    describe "with invalid params" do
      before { User.any_instance.stub(:save).and_return(false) }
      describe "missing logname" do
        before { post :create, {:user => FactoryGirl.attributes_for(:user, logname: "")} }

        it "assigns a newly created but unsaved user as @user" do
          assigns(:user).should be_a_new(User)
        end

        it "re-renders the 'new' template" do
          response.should render_template("new")
        end
      end
    end
  end

end
