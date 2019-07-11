# frozen_string_literal: true

require 'rails_helper'
RSpec.describe UpdateClearstreamMsgStatusFromWebhookWorker, type: :worker do
  let!(:clearstream_msg) { create(:clearstream_msg, clearstream_id: 128_695) }
  let!(:clearstream_msg_event) { JSON.parse(get_clearstream_response_data('webhook_params')) }

  it 'updates the clearstream msg we pass' do
    UpdateClearstreamMsgStatusFromWebhookWorker.perform_async(clearstream_msg_event)
    expect(ClearstreamMsg.first.status).to eq 'SENT'
  end
end
