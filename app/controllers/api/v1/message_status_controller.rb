class Api::V1::MessageStatusController < Api::V1::ApiBaseController
  include StatusHelper

  # Note that message.target should be updated by delayed job upon change of status.
  def show
    message = Message.find(params[:id])
    if message.nil?
      render_error_msg("No message found for message_id (#{params[:id]})")
    else
      # message.target will be populated when the target (SendGrid/Clearstream) processes the message.
      target = message.target
      if target.nil?
        if message.target_name
          msg = "Message for message_id (#{params[:id]}) has been sent for processing to #{message.target_name} "
          render_success_msg(msg)
        else
          msg = "Message for message_id (#{params[:id]}) was received, but has an invalid target (#{target})"
          render_error_msg(msg)
        end
      else
        # This will likely not occur now that processing is asynchronous.
        render_response target
      end
    end
  end
end
