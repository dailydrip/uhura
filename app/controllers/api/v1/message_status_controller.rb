class Api::V1::MessageStatusController < Api::V1::ApiBaseController
  include StatusHelper

  # Note that message.target should be updated by delayed job upon change of status.
  def show
    target = Message.find(params[:id]).target
    if target.nil?
      render_error_msg("No message was sent to any target for message_id (#{params[:id]})")
    else
      render_response target
    end
  end
end
