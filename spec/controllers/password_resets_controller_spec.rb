require 'rails_helper'

RSpec.describe PasswordResetsController, type: :controller do

  let(:user) { FactoryGirl.create(:user)}

  describe '#new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template('new')
    end
  end

  describe '#create' do

    context 'with valid user and email' do
      it "finds the user" do
        expect(User).to receive(:find_by).with(email: user.email).and_return(user)
        post :create, email: user.email
      end

      it "generates a new password reset token" do
        expect{ post :create, email: user.email; user.reload }.to change{user.password_reset_token}
      end

      it "sends a password reset email" do
        expect{ post :create, email: user.email }.to change(ActionMailer::Base.deliveries, :size)
      end
    end

    context "with no user found" do
      it "renders the new page" do
        post :create, email: 'none@found.com'
        expect(response).to render_template('new')
      end

      it "sets the flash message" do
        post :create, email: "none@found.com"
        expect(flash[:alert]).to match("Email not found.")
      end
    end
  end

  describe "#edit" do
    context "with a valid password_reset_token" do
      before { user.generate_password_reset_token! }

      it "renders the edit template" do
        get :edit, id: user.password_reset_token
        expect(response).to render_template('edit')
      end
    end

    context "with no password_reset_token found" do
      it "renders the 404 page" do
        get :edit, id: 'notfound'
        expect(response.status).to eq(404)
        expect(response).to render_template(file: "#{Rails.root}/public/404.html")
      end
    end
  end

  describe "#update" do
    context "with no token found" do
      it "renders the edit page" do
        patch :update, id: 'notfound', user: { password: 'newpassword1', password_confirmation: 'newpassword1' }
        expect(response).to render_template('edit')
      end
    end

    context "with a valid token" do
      before { user.generate_password_reset_token! }

      it "updates the user's password" do
        digest = user.password_digest
        patch :update, id: user.password_reset_token, user: { password: 'newpassword1', password_confirmation: 'newpassword1' }
        user.reload
        expect(user.password_digest).to_not eq(digest)
      end

      it "clears the password_reset_token" do
        patch :update, id: user.password_reset_token, user: { password: 'newpassword1', password_confirmation: 'newpassword1' }
        user.reload
        expect(user.password_reset_token).to be_blank
      end
    end
  end
end
