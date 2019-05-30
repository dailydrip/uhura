# frozen_string_literal: true

# rubocop:disable all
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
    # Verify that data from message, manager and team are valid then send message.
    if !message_params_vo.valid?
      msg = message_params_vo.errors.full_messages
      ret = ReturnVo.new(value: nil, error: return_error(msg, :unprocessable_entity))
      err_msg = {
        "msg": 'Invalid message_params_vo parameters received. Message was not processed.',
        "error": msg,
        "message_params_vo": message_params_vo
      }
      log_error(err_msg)
    else
      manager_team_vo = ManagerTeamVo.new(
        manager_id: @manager.id, # A manager is the sending app.
        manager_name: @manager.name,
        manager_email: @manager.email,
        team_name: @team_name
      )
      unless manager_team_vo.valid?
        msg = manager_team_vo.errors.full_messages
        ret = ReturnVo.new(value: nil, error: return_error(msg, :unprocessable_entity))
        err_msg = {
          "msg": 'Invalid manager_team_vo parameters received. Message was not processed.',
          "error": msg,
          "message_params_vo": message_params_vo
        }
        log_error(err_msg)
      end
    end
    if ret&.error?
      # Uhura received bad input; unable to form request.
      render json: ret.error, status: :unprocessable_entity
    else
      # Both message_params_vo, manager_team_vo params are valid.
      message_vo = MessageVo.new(message_params_vo, manager_team_vo)
      # Send message (MessageDirector will determine if its an Email or SMS message).
      ret = MessageDirector.send(message_vo)
      if ret&.error?
        render json: ret.error, status: :unprocessable_entity
      else
        render json: ret.value
      end
    end
  end

  def index
    @messages = @manager.messages
    render json: @messages
  end
end
# rubocop:enable all
