# frozen_string_literal: true

FactoryBot.define do
  factory :clearstream_msg do
    status { 'QUEUED' }
  end
end
