require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  set_mapping
  set_content_type 'application/json'

  context "POST #create" do
    let(:email){ FactoryGirl.attributes_for(:user)[:email] }
    let(:password){ FactoryGirl.attributes_for(:user)[:password] }

    after do
      DatabaseCleaner.clean
    end

    context "valid parameters" do
      before do
        post :create, user: {email: email, password: password}
      end

      it "returns 201 HTTP status code" do
        expect(response).to have_http_status :created
      end

      it "creates an user" do
        expect(User.count).to eql 1
      end

      it "assigns the correct email" do
        expect(User.first.email).to eql email
      end

      it "assigns the correct password" do
        expect(User.first.valid_password?(password)).to eql true
      end

      it "assigns an auth token" do
        expect(User.first.authentication_token).to_not be_nil
      end
    end

    context "invalid parameters" do
      before do
        post :create, user: {email: 'wrong@email.com', password: 'bad'}
      end

      it "returns 422 HTTP status code" do
        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end
end
