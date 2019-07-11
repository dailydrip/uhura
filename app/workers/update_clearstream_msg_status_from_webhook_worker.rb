# frozen_string_literal: true

class UpdateClearstreamMsgStatusFromWebhookWorker
  include Sidekiq::Worker

  def perform(event)
    status = event['status']
    message_id = event['id']
    clearstream_msg = ClearstreamMsg.find_by(clearstream_id: message_id)
    if clearstream_msg
      clearstream_msg.status = status
      clearstream_msg.save!
      clearstream_msg_event = ClearstreamMsgEvent.create(clearstream_msg_id: clearstream_msg.id,
                                                         status: status,
                                                         event_details: event)
      if clearstream_msg_event.nil?
        log_error("Unable to create ClearstreamMsgEvent for event: #{event}")
      end
    else
      log_error("ClearstreamMsg.find_by(clearstream_id: #{message_id}) not found. Unable to save status (#{status}) or create ClearstreamMsgEvent.")
    end
  end
end
