# frozen_string_literal: true

class UpdateClearstreamMsgStatusFromWebhookWorker
  include Sidekiq::Worker

  def perform(clearstream_id, status)
    clearstream_msg = ClearstreamMsg.find_by(clearstream_id: clearstream_id)
    clearstream_msg.status = status
    clearstream_msg.save!
  end
end
