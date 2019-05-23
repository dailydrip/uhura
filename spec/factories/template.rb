# frozen_string_literal: true

FactoryBot.define do
  factory :template do
    name { Faker::Lorem.word }
    template_id { 'd-f986df533e514f978f4460bedca50db0' }
  end
end
