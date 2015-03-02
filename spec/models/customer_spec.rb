require 'rails_helper'

RSpec.describe Customer, type: :model do
  context 'Document' do
    it { is_expected.to be_timestamped_document }
  end

  context 'Fields' do
    it { is_expected.to have_field(:name).of_type(String) }
    it { is_expected.to have_field(:address).of_type(String) }
    it { is_expected.to have_field(:town).of_type(String) }
    it { is_expected.to have_field(:city).of_type(String) }
    it { is_expected.to have_field(:country).of_type(String) }
    it { is_expected.to have_field(:zip_code).of_type(String) }
    it { is_expected.to have_field(:cif).of_type(String) }
    it { is_expected.to have_field(:email).of_type(String) }
    it { is_expected.to have_field(:phone).of_type(String) }
  end

  context "Relations" do
    it { is_expected.to have_many(:projects) }
    it { is_expected.to belong_to(:user) }
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:phone) }
    it { is_expected.to validate_presence_of(:address) }
    it { is_expected.to validate_presence_of(:town) }
    it { is_expected.to validate_presence_of(:city) }
    it { is_expected.to validate_presence_of(:country) }
    it { is_expected.to validate_presence_of(:cif) }
    it { is_expected.to validate_presence_of(:user) }

    it { is_expected.to validate_uniqueness_of(:cif).case_insensitive }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

    it {
      is_expected.to validate_format_of(:email)
        .to_allow('email@example.com')
        .not_to_allow('email')
        .not_to_allow('email@example')
        .not_to_allow('email@example,com')
        .not_to_allow('@example.com')
        .not_to_allow('example.com')
        .not_to_allow('email@')
        .not_to_allow('.com')
    }
  end
end
