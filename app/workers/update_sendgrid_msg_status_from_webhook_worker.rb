# frozen_string_literal: true

class UpdateSendgridMsgStatusFromWebhookWorker
  include Sidekiq::Worker

  def perform(event)
    status = event['event']
    message_id = event['uhura_msg_id']
    sendgrid_msg = SendgridMsg.find_by(id: message_id)
    if sendgrid_msg
      sendgrid_msg.status = status
      sendgrid_msg.read_by_user_at = Time.at(event['timestamp']).in_time_zone
      sendgrid_msg.save!

      SendgridMsgEvent.create!(
        sendgrid_msg_id: message_id,
        status: status,
        event: event
      )
    else
      log_error("SendgridMsg.find(#{message_id}) not found. Unable to save status or create SendgridMsgEvent.")
    end
  end
end
