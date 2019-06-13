# frozen_string_literal: true

# rubocop:disable all
class Api::V1::MessagesController < Api::V1::ApiBaseController
  include StatusHelper
  before_action :set_team_name

  def set_team_name
    return if params[:action]&.eql?('status')
    x_team_id = request.headers['X-Team-ID']
    err_msg = nil
    if x_team_id.nil? || x_team_id.strip.size.eql?(0)
      err_msg = 'Required HTTP header (X-Team-ID) is missing.'
    else
      team = Team.find_by(id: x_team_id)
      if team.nil?
        err_msg = "Team ID (#{x_team_id}) from the X-Team-ID HTTP header NOT found! "
        err_msg += "Consider adding Team for ID (#{x_team_id}) using the Admin app on the Teams page."
      else
        @team_name = team.name
      end
    end
    if err_msg
      render_error_msg(err_msg)
    end
  end

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
      # render json: ret.error, status: :unprocessable_entity

      # Unable to collect data for a proper send request
      render_response(ret)
    else
      # Both message_params_vo, manager_team_vo params are valid.
      message_vo = MessageVo.new(message_params_vo, manager_team_vo)
      # message_vo is valid. MessageDirector will determine if its an Email or SMS message.
      return_vo = MessageDirector.send(message_vo) # <= Send message!
      if return_vo.is_error?  #message_vo.message_id.nil?
        # Store failed message attempt
        invalid_message = InvalidMessage.create!(
            message_vo.invalid_message_attrs.merge(
                message_params: message_params_vo.message_params,
                message_attrs: message_vo.to_hash,
                )
        )
        # There are no ClearstreamMsg or SendgridMsg FKeys since message was not sent
        render_error_status(invalid_message.id)
      else
        render_success_status(message_vo.message_id)
      end
    end
  end

  def index
    render_response @manager.messages
  end

  def render_error_status(invalid_message)
    msg = "Invalid message. Go here (#{api_v1_invalid_message_status_url(invalid_message)}) for details on it later."
    render_success_msg(msg)
  end

  def render_success_status(message_id)
    message = Message.find(message_id)
    msg = "We got the message. Go here (#{api_v1_message_status_url(message)}) for details on it later."
    render_success_msg(msg)
  end


  def report76
    #generate_report

    clearstream_vo = {
        "resource": "messages",
        "message_id": 76,
        "mobile_number": "+17707651573‬",
        "message_header": "Leadership Team",
        "message_body": "Come in now for 50% off all rolls!",
        "subscribers": "+17707651573‬",
        "schedule": false,
        "send_to_fb": false,
        "send_to_tw": false
    }
    ClearstreamMessageWorker.perform_async(clearstream_vo)
    render_success_status(clearstream_vo[:message_id])
  end

  private

  def generate_report
    sleep 3
  end

end
# rubocop:enable all
