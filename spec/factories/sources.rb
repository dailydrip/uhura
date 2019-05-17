FactoryBot.define do
  factory :source do
    name { Faker::Name.last_name }
  end
end
