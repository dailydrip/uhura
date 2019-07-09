# frozen_string_literal: true

class Api::V1::WebHooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def sendgrid
    # Rails automatically handles the JSON data and maps it into the object:  params["_json"]
    events = params['_json']
    events&.each do |event|
      status = event['event']
      message_id = event['uhura_msg_id']
      UpdateSendgridMsgStatusFromWebhookWorker.perform_async(message_id, status)
    end
  end

  def clearstream
    status = params[:data][:message][:status]
    clearstream_id = params[:data][:message][:id]
    UpdateClearstreamMsgStatusFromWebhookWorker.perform_async(clearstream_id, status)
  end
end
