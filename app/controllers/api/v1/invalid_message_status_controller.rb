class Api::V1::InvalidMessageStatusController < Api::V1::ApiBaseController
  include StatusHelper

  # Note that message.target should be updated by delayed job upon change of status.
  def show
    invalid_message = InvalidMessage.find(params[:id])
    if invalid_message.nil?
      render_error_msg("Unable to find invalid message (#{params[:id]})")
    else
      render_response invalid_message
    end
  end
end
