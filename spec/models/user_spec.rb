require 'rails_helper'

RSpec.describe User, type: :model do
  context "Document" do
    it { is_expected.to be_timestamped_document }
  end

  context "Fields" do
    it { is_expected.to have_field(:authentication_token).of_type(String) }
  end

  context "Relations" do
    it { is_expected.to have_many(:customers) }
  end

  context "Custom methods" do
    context "auth token" do
      let(:user){ FactoryGirl.create(:user, authentication_token: nil) }

      context "#ensure_authentication_token!" do
        it "should generate an authentication token" do
          user.ensure_authentication_token!

          expect(user.authentication_token).to_not be_nil
        end
      end

      context "#destroy_authentication_token!" do
        it "should remove the authentication token" do
          user.ensure_authentication_token!
          user.destroy_authentication_token!

          expect(user.authentication_token).to be_nil
        end
      end
    end
  end
end
