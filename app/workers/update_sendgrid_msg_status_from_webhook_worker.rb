# frozen_string_literal: true

class UpdateSendgridMsgStatusFromWebhookWorker
  include Sidekiq::Worker

  def perform(message_id, status)
    sendgrid_msg = SendgridMsg.find(message_id)
    if sendgrid_msg
      sendgrid_msg.status = status
      sendgrid_msg.save!
    end
  end
end
