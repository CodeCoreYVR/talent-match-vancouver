require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  let(:user) {FactoryGirl.create(:user)}

  describe "new" do
    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end

    it "it instantiates a user object and assigns it to @user instance" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end # End of the describe new

  describe "create" do

    def valid_create_request
      post :create, user: FactoryGirl.attributes_for(:user)
    end

    context "successful create"
      it "creates a record in the database" do
        expect{valid_create_request}.to change{User.count}.by(1)
      end

      it "redirects to the homepage" do
        valid_create_request
        expect(response).to redirect_to(root_path)
      end

      it "sets a flash notice method" do
        valid_create_request
        expect(flash[:success]).to be
      end

      it "sets the current session's user_id to the newly created user" do
        valid_create_request
        expect(session[:user_id]).to eq(User.last.id)
      end

    context "unsuccesful create"

      def invalid_create_request
        post :create, user: FactoryGirl.attributes_for(:user, {email: nil})
      end

      it "doesnt create a record in the database" do
        expect{invalid_create_request}.not_to change{User.count}
      end

      it "renders the new template" do
        invalid_create_request
        expect(response).to render_template(:new)
      end

      it "sets a flash alert method" do
        invalid_create_request
        expect(flash[:alert]).to be
      end
  end # End of the describe create

  describe "edit" do

    before do
      get :edit, id: user.id
    end

    it "renders the edit user template" do
      expect(response).to render_template(:edit)
    end

    it "finds the user by id and sets it to the @user instance variable" do
      expect(assigns(:user)).to eq(user)
    end
  end # End of the describe edit

  describe "update" do


    context "successful update" do #valid parameters passed

      before do
        patch :update, id: user.id, user: {first_name: "New Name"}
      end

      it "updates the record with the new parameter" do
        expect(user.reload.first_name).to eq("New Name")
      end

      it "redirects to the homepage" do
        expect(response).to redirect_to(root_path)
      end

      it "sets a flash notice method" do
        expect(flash[:success]).to be
      end

    end

    context "unsuccesful update" do #invalid parameters passed

      def invalid_update_request
        patch :update, id: user.id, user: {first_name: ""}
      end

      it "doesn't update the record" do
        first_name_before = user.first_name
        invalid_update_request
        expect(user.reload.first_name).to eq(first_name_before)
      end

      it "renders the edit template" do
        invalid_update_request
        expect(response).to render_template(:edit)
      end

      it "sets a flash alert method" do
        invalid_update_request
        expect(flash[:alert]).to be
      end
    end
  end # End of the describe update

  describe "destroy" do

    before do
      delete :destroy, id: user.id
    end

    it "finds the user by id and sets it to the @user instance" do
      expect(assigns(:user)).to eq(user)
    end

    it "redirect_to the root path" do
      expect(response).to redirect_to(root_path)
    end
  end
end
