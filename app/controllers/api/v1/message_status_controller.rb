# frozen_string_literal: true

class Api::V1::MessageStatusController < Api::V1::ApiBaseController
  include StatusHelper

  # Note that message.target should be updated by delayed job upon change of status.
  def show
    message = Message.find(params[:id])
    if message.nil?
      render_error_msg("No message found for message_id (#{params[:id]})")
    else
      render json: {
          message_status: message.status
      }
    end
  end
end
