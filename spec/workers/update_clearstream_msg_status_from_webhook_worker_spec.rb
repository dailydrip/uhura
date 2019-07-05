# frozen_string_literal: true

require 'rails_helper'
RSpec.describe UpdateClearstreamMsgStatusFromWebhookWorker, type: :worker do
  let!(:clearstream_msg) { create(:clearstream_msg, clearstream_id: 99_999) }

  it 'updates the clearstream msg we pass' do
    Sidekiq::Testing.inline! { UpdateClearstreamMsgStatusFromWebhookWorker.perform_async(clearstream_msg.clearstream_id, 'open') }
    expect(ClearstreamMsg.first.status).to eq 'open'
  end
end
