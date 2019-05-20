# frozen_string_literal: true

FactoryBot.define do
  factory :source do
    name { Faker::Name.last_name }
  end
end
