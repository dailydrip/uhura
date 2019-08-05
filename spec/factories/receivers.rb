# frozen_string_literal: true

FactoryBot.define do
  factory :receiver do
    receiver_sso_id { Faker::Number.number }
    email { Faker::Internet.email }
    mobile_number { Faker::PhoneNumber.cell_phone }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    preferences { { 'email': false, 'sms': true } }
  end
end
