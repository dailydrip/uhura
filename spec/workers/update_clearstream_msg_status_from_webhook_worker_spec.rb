require 'rails_helper'
RSpec.describe UpdateClearstreamMsgStatusFromWebhookWorker, type: :worker do
  let!(:msg) { create(:clearstream_msg) }

  it 'updates the clearstream msg we pass' do
    Sidekiq::Testing.inline! { UpdateClearstreamMsgStatusFromWebhookWorker.perform_async(msg.id, 'open') }
    expect(ClearstreamMsg.first.status).to eq 'open'
  end
end
