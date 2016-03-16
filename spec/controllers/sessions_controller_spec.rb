require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  let(:user) { FactoryGirl.create(:user) }

  describe "#new" do
    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "#create" do
    def sign_in_user
      post :create, { email: user.email, password: user.password }
    end
    def bad_credentials
      post :create, { email: "invalid@email.no", password: user.password }
    end
    def bad_password
      post :create, { email: user.email, password: user.last_name }
    end
    context "with valid credentials" do
      it "sets the session user_id to the user with the passed email" do
        sign_in_user
        expect(session[:user_id]).to eq(user.id)
      end
      it "redirects to the root path" do
        sign_in_user
        expect(response).to redirect_to(root_path)
      end
    end
    context "with invalid credentials" do
      it "renders the sign-in page (new template)" do
        bad_credentials
        expect(response).to render_template(:new)
      end
      it "sets a flash alert message" do
        bad_credentials
        expect(flash[:alert]).to be
      end
      it "doesn't set the session user_id if email correct but password wrong" do
        bad_password
        expect(session[:user_id]).to eq(nil)
      end
    end
  end

  describe "#destroy" do
    before do
      request.session[:user_id] = user.id
      delete :destroy
    end
    it "sets session user_id to nil" do
      expect(session[:user_id]).to eq(nil)
    end
    it "sets a flash notice" do
      expect(flash[:notice]).to be
    end
    it "redirects to the root_path" do
      expect(response).to redirect_to(signup_path)
    end
  end

end
