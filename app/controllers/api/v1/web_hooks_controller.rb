# frozen_string_literal: true

class Api::V1::WebHooksController < ApplicationController
  def sendgrid
    # sendgrid send us an array and this is the way rails does that
    events = params['_json']
    events.each do |event|
      status = event['event']
      message_id = event['sg_message_id']
      sendgrid_msg = SendgridMsg.find_by(x_message_id: message_id)

      if sendgrid_msg
        sendgrid_msg.status = status
        sendgrid_msg.save!
      end
    end
  end
end
