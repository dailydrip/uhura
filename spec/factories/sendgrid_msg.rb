# frozen_string_literal: true

FactoryBot.define do
  factory :sendgrid_msg do
    status { 'accepted_by_sendgrid' }
  end
end
