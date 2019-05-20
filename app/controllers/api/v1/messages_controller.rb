# frozen_string_literal: true

class Api::V1::MessagesController < Api::V1::ApiBaseController
  def create
    message_params_vo = MessageParamsVo.new(
      public_token: params[:public_token],
      receiver_sso_id: params[:receiver_sso_id],
      email_subject: params[:email_subject],
      email_message: params[:email_message],
      template_id: params[:template_id],
      sms_message: params[:sms_message]
    )



    if !message_params_vo.valid?
      msg =  message_params_vo.errors.full_messages
      ret = ReturnVo.new(value: nil, error: return_error(msg, :unprocessable_entity))
      err_msg = {
          "msg": "Invalid parameters received. Message was not processed.",
          "error": msg,
          "message_params_vo": message_params_vo
      }
      log_error(err_msg)
    else
      message_vo = MessageVo.new(message_params_vo)
      # Now that params have been validated, assign attributes gathered in base_api controller
      message_vo.manager_id = @manager.id # A manager is the sending app.
      message_vo.manager_email = @manager.email
      message_vo.manager_name = @manager.name
      message_vo.team_name = @team_name
      # Send message
      ret = MessageDirector.send(message_vo)
    end

    if !ret.error.nil?
      render json: ret.error, status: :unprocessable_entity
    else
      render json: ret.value
    end
  end

  def index
    @messages = @manager.messages
    render json: @messages
  end
end
