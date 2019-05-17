# frozen_string_literal: true

FactoryBot.define do
  factory :team do
    name { Faker::Name.last_name }
  end
end
