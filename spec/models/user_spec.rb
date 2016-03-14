require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user) { FactoryGirl.create(:user)}
  
    describe "Validations" do

      it "requires a first name" do
        u = User.new
        u.valid?
        expect(u.errors).to have_key(:first_name)
      end

      it "requires a email" do
        u = User.new
        u.valid?
        expect(u.errors).to have_key(:email)
      end

      it "reqiures a password" do
        u = User.new
        u.valid?
        expect(u.errors).to have_key(:password)
      end

      it "requires a unique email" do
        user_two = User.new(email: user.email)
        user_two.valid?
        expect(user_two.errors).to have_key(:email)
      end

    end

    describe ".full_name"  do

      it "concatenates the first name and the last name" do
        expect(user.full_name).to include("#{user.first_name}", "#{user.last_name}")
      end

      it "returns first name if the last name is missing" do
        u = FactoryGirl.build(:user, {last_name: nil})
        expect(u.full_name).to eq("#{u.first_name}")
      end

    end

    describe "password generating" do

      it "generates a password digest on creation" do
        expect(user.password_digest).to be
      end

    end


end
