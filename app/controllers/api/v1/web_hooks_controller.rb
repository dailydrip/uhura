# frozen_string_literal: true

class Api::V1::WebHooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def sendgrid
    puts "\n\n>> WebHooksController.sendgrid called params['_json']: #{params['_json']}\n\n"
    # sendgrid send us an array and this is the way rails does that
    events = params['_json']
    events&.each do |event|
      status = event['event']
      message_id = event['uhura_msg_id']
      #UpdateSendgridMsgStatusFromWebhookWorker.perform_async(message_id, status)
      tmp_perform_sendgrid_task(message_id, status)
    end
  end

  def tmp_perform_sendgrid_task(message_id, status)
    sendgrid_msg = SendgridMsg.find(message_id)
    if sendgrid_msg
      sendgrid_msg.status = status
      sendgrid_msg.save!
    else
      log_warn("WebHooksController - SendgridMsg.find(#{message_id}) not found!")
    end
  end


  def clearstream
    puts ">> WebHooksController.clearstream called params['_json']: #{params['_json']}"

    clearstream_id = params[:data][:message][:id]
    status = params[:data][:message][:status]
    #UpdateClearstreamMsgStatusFromWebhookWorker.perform_async(clearstream_msg_id, status)
    tmp_perform_clearstream_task(clearstream_id, status)
  end

  def tmp_perform_clearstream_task(clearstream_id, status)
    clearstream_msg = ClearstreamMsg.find_by(clearstream_id: clearstream_id)
    if clearstream_msg
      clearstream_msg.status = status
      clearstream_msg.save!
    else
      log_warn("WebHooksController - ClearstreamMsg.find(#{clearstream_id}) not found!")
    end
  end
end
