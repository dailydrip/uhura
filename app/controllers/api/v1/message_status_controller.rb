class Api::V1::MessageStatusController < Api::V1::ApiBaseController
  include StatusHelper

  # Note that message.target should be updated by delayed job upon change of status.
  def show
    render_response Message.find(params[:id]).target
  end
end
