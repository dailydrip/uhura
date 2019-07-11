# frozen_string_literal: true

class Api::V1::WebHooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def sendgrid
    # Rails automatically handles the JSON data and maps it into the object:  params["_json"]
    events = params['_json']
    events&.each do |event|
      UpdateSendgridMsgStatusFromWebhookWorker.perform_async(JSON.parse(event.to_json))
    end
  end

  def clearstream
    message_hash = JSON.parse(params[:data][:message].to_json)
    UpdateClearstreamMsgStatusFromWebhookWorker.perform_async(message_hash)
  end
end
