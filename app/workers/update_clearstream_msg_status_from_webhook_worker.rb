class UpdateClearstreamMsgStatusFromWebhookWorker
  include Sidekiq::Worker

  def perform(clearstream_msg_id, status)
    clearstream_msg = ClearstreamMsg.find(clearstream_msg_id)
    clearstream_msg.status = status
    clearstream_msg.save!
  end
end
