class Api::V1::MessagesController < Api::V1::ApiBaseController

  def create

    message_vo = MessageVo.new({
                                manager_id: @manager.id, # A manager is the sending app.
                                manager_email: @manager.email,
                                manager_name: @manager.name,
                                team_name: @team_name,
                                receiver_sso_id: params[:receiver_sso_id],
                                email_subject: params[:email_subject],
                                email_message: params[:email_message]&.to_json,
                                template_id: params[:template_id],
                                sms_message: params[:sms_message]
    })

    ret = MessageDirector.send(message_vo)
    if !ret.error.nil?
      # Failed to deliver message
      render json: ret.error
    else
      render json: ret.value
    end
  end

  def index
    @messages = @manager.messages
    render json: @messages
  end
end
