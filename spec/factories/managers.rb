# frozen_string_literal: true

FactoryBot.define do
  factory :manager do
    name { Faker::Company.name }
  end
end
