class Api::V1::MessagesController < Api::V1::ApiBaseController

  def create

    message = MessageVo.new({
                                manager_id: @manager.id,
                                manager_email: @manager.email,
                                manager_name: @manager.name,
                                team_name: params[:team_name],
                                receiver_email: params[:receiver_email],
                                email_subject: params[:email_subject],
                                email_message: params[:email_message],
                                template_id: params[:template_id],
                                sms_message: params[:sms_message]
                            })

    ret = MessageDirector.send(message)
    if !ret.error.nil?
      # Failed to deliver message
      render json: ret.error
    else
      render json: return_success(ret.value)
    end
  end

  def index
    @messages = @manager.messages
    render json: @messages
  end
end
