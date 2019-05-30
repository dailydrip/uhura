# frozen_string_literal: true

FactoryBot.define do
  factory :msg_target do
    name { Faker::Name.last_name }
  end
end
