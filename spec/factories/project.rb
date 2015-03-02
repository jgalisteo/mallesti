FactoryGirl.define do
  factory :project do
    name
    description { Faker::Lorem.paragraph }
  end

  factory :project_update, parent: :project do
    name        "A new name"
    description "A new description"
  end
end
