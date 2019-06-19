# frozen_string_literal: true

class Api::V1::MessagesController < Api::V1::ApiBaseController
  include StatusHelper
  before_action :set_team_name

  def index
    render_response @manager.messages
  end

  def create
    err = validate_params
    if err != nil
        render_error_msg(err)
    else
      message_vo = MessageVo.new(message_params_vo, manager_team_vo)
      return_vo = MessageDirector.send(message_vo)

      return_vo.error? ? render_message_director_error(message_vo) : render_success_status(message_vo.message_id)
    end
  end

  private

  def render_message_director_error(message_vo)
    invalid_message = InvalidMessage.create!(
        message_vo.invalid_message_attrs.merge(
            message_params: message_params_vo.message_params,
            message_attrs: message_vo.to_hash
        )
    )
    render_error_status(invalid_message.id)
  end

  def validate_params
    err = validate_message_params(message_params_vo)
    return err[:error] if err != nil
    err = validate_manager_team_params(manager_team_vo)
    return err[:error] if err != nil
  end


  def validate_message_params(message_params_vo)
    if !message_params_vo.valid?
      msg = message_params_vo.errors.full_messages
      err_msg = {
          "msg": 'Invalid message_params_vo parameters received. Message was not processed.',
          "error": msg,
          "message_params_vo": message_params_vo
      }
      return_error(err_msg)
    end
  end

  def validate_manager_team_params(manager_team_vo)
    if !manager_team_vo.valid?
      msg = manager_team_vo.errors.full_messages
      err_msg = {
          "msg": 'Invalid manager_team_vo parameters received. Message was not processed.',
          "error": msg,
          "message_params_vo": message_params_vo
      }
      return_error(err_msg)
    end
  end

  def message_params_vo
    MessageParamsVo.new(
      public_token: params[:public_token],
      receiver_sso_id: params[:receiver_sso_id],
      email_subject: params[:email_subject],
      email_message: params[:email_message],
      email_options: params[:email_options],
      template_id: params[:template_id],
      sms_message: params[:sms_message]
    )
  end

  def manager_team_vo
    ManagerTeamVo.new(
      manager_id: @manager.id, # A manager is the sending app.
      manager_name: @manager.name,
      manager_email: @manager.email,
      team_name: @team_name
    )
  end

  def render_error_status(invalid_message)
    msg = "Invalid message. Go here (#{api_v1_invalid_message_status_url(invalid_message)}) for details on it later."
    render_error_msg(msg)
  end

  def render_success_status(message_id)
    message = Message.find(message_id)
    msg = "We got the message. Go here (#{api_v1_message_status_url(message)}) for details on it later."
    render_success_msg(msg)
  end

  def set_team_name
    return if params[:action]&.eql?('status')

    x_team_id = request.headers['X-Team-ID']
    if x_team_id.nil? || x_team_id.strip.size.eql?(0)
      err_msg = 'Required HTTP header (X-Team-ID) is missing.'
    else
      team = Team.find_by(id: x_team_id)
      team.nil? ? err_msg = error_message_for_team(x_team_id) : @team_name = team.name
    end
    render_error_msg(err_msg) if err_msg
  end

  def error_message_for_team(x_team_id)
    err_msg = "Team ID (#{x_team_id}) from the X-Team-ID HTTP header NOT found! "
    err_msg += "Consider adding Team for ID (#{x_team_id}) using the Admin app on the Teams page."
    err_msg
  end
end
