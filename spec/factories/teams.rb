FactoryBot.define do
  factory :team do
    name { Faker::Name.last_name }
  end
end
