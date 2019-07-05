# frozen_string_literal: true

class Api::V1::WebHooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def sendgrid
    # Rails automatically handles the JSON data and maps it into the object:  params["_json"]
    events = params['_json']
    events&.each do |event|
      status = event['event']
      message_id = event['uhura_msg_id']
      # perform_sync_sendgrid_task(message_id, status) # <= Uncomment to test synchronously
      UpdateSendgridMsgStatusFromWebhookWorker.perform_async(message_id, status)
    end
  end

  def perform_sync_sendgrid_task(message_id, status)
    sendgrid_msg = SendgridMsg.find(message_id)
    if sendgrid_msg
      sendgrid_msg.status = status
      sendgrid_msg.save!
    else
      log_warn("WebHooksController - SendgridMsg.find(#{message_id}) not found!")
    end
  end

  def clearstream
    status = params[:data][:message][:status]
    clearstream_id = params[:data][:message][:id]
    # perform_sync_clearstream_task(clearstream_id, status) # <= Uncomment to test synchronously
    UpdateClearstreamMsgStatusFromWebhookWorker.perform_async(clearstream_id, status)
  end

  def perform_sync_clearstream_task(clearstream_id, status)
    clearstream_msg = ClearstreamMsg.find_by(clearstream_id: clearstream_id)
    if clearstream_msg
      clearstream_msg.status = status
      clearstream_msg.save!
    else
      log_warn("WebHooksController - ClearstreamMsg.find(#{clearstream_id}) not found!")
    end
  end
end
