# frozen_string_literal: true

require 'rails_helper'
RSpec.describe UpdateSendgridMsgStatusFromWebhookWorker, type: :worker do
  let!(:msg) { create(:sendgrid_msg) }

  it 'updates the sendgrid msg we pass' do
    # Inline testing configured in intitializer: Sidekiq::Testing.inline!
    UpdateSendgridMsgStatusFromWebhookWorker.perform_async(msg.id, 'open')
    expect(SendgridMsg.first.status).to eq 'open'
  end
end
