# frozen_string_literal: true

require 'rails_helper'
RSpec.describe UpdateSendgridMsgStatusFromWebhookWorker, type: :worker do
  let!(:sendgrid_msg) { create(:sendgrid_msg, id: 'e7664350-e791-4c4f-a78e-d68f1f924c2b') }
  let!(:sendgrid_msg_event) { JSON.parse(get_sendgrid_response_data('webhook_params'))['_json'][0] }

  it 'updates the sendgrid msg we pass' do
    # Inline testing configured in intitializer: Sidekiq::Testing.inline!
    UpdateSendgridMsgStatusFromWebhookWorker.perform_async(sendgrid_msg_event)
    expect(SendgridMsg.first.status).to eq 'processed'
  end
end
