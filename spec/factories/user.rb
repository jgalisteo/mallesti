FactoryGirl.define do
  factory :user do
    email
    password "foobarfoo"
    authentication_token { Devise.friendly_token }

    before(:create) do |user|
      user.skip_confirmation!
    end
  end
end
