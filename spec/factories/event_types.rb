# frozen_string_literal: true

FactoryBot.define do
  factory :event_type do
    name { Faker::Name.first_name }
  end
end
