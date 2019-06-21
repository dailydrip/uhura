# frozen_string_literal: true

FactoryBot.define do
  factory :message do
    msg_target { create(:msg_target) }
    sendgrid_msg { create(:sendgrid_msg) }
    clearstream_msg { create(:clearstream_msg) }
    manager { create(:manager) }
    receiver { create(:receiver) }
    team { create(:team) }
    template { create(:template) }
  end
end
