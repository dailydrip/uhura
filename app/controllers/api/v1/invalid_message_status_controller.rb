class Api::V1::InvalidMessageStatusController < Api::V1::ApiBaseController
  include StatusHelper

  # Note that message.target should be updated by delayed job upon change of status.
  def show
    # If an ActiveRecord::RecordNotFoun error occurs, the ErrorHandler will handle it.
    invalid_message = InvalidMessage.find(params[:id])
    # If InvalidMessage.find failed to find a record the ErrorHandler will render the response.
    render_response invalid_message
  end
end
