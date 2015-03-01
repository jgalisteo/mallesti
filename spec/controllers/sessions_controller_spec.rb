require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  set_mapping
  set_content_type 'application/json'

  let(:user){ FactoryGirl.create(:user) }
  let(:password){ FactoryGirl.attributes_for(:user)[:password] }


  context "POST #create" do
    context "valid parameters" do
      before do
        post :create, email: user.email, password: password
      end

      it "returns 201 HTTP status code" do
        expect(response).to have_http_status :created
      end

      context "Attributes" do
        [:id, :email, :authentication_token].each do |attr|
          it "include the attribute #{attr}" do
            expect(response_body_json['user']).to have_key(attr.to_s)
          end

          it "return the correct value for attribute #{attr}" do
            json_value  = response_body_json['user'][attr.to_s]
            param_value = user.send(attr).as_json

            expect(json_value).to eql param_value
          end
        end
      end
    end

    context "Unauthorized" do
      context "invalid parameters" do
        before do
          post :create, email: user.email
        end

        it "returns 401 HTTP status code" do
          expect(response).to have_http_status :unauthorized
        end

        it "returns 'invalid' message" do
          expect(response_body_json['errors']).to eql ['invalid']
        end
      end

      context "unconfirmed" do
        before do
          user.update_attribute(:confirmed_at, nil)
          post :create, email: user.email, password: password
        end

        it "returns 401 HTTP status code" do
          expect(response).to have_http_status :unauthorized
        end

        it "returns 'invalid' message" do
          expect(response_body_json['errors']).to eql ['unconfirmed']
        end
      end
    end
  end
end
