# frozen_string_literal: true

class Api::V1::WebHooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def sendgrid
    # sendgrid send us an array and this is the way rails does that
    events = params['_json']
    events&.each do |event|
      status = event['event']
      message_id = event['uhura_msg_id']
      UpdateSendgridMsgStatusFromWebhookWorker.perform_async(message_id, status)
    end
  end
end
