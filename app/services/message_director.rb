# frozen_string_literal: true

# MessageDirector acts as a service, sending and email and/or an sms message

class MessageDirector
  def self.send(message_vo)
    ret = create_message(message_vo)
    if !ret.error.nil?
      return ret
    else
      # Message request has been fully validated and populated.
      message_vo.message_id = ret.value.id # Set message_id. Used to link SendgridMsg to Message later.
    end

    ret_sendgrid = SendgridHandler.send(message_vo) if message_vo.preferences['email']
    ret_clearstream = ClearstreamHandler.send(message_vo) if message_vo.preferences['sms']
    {sendgrid: ret_sendgrid, clearstream: ret_clearstream}
  end

  def self.create_message(message_vo)
    if message_vo.valid?
      message = Message.create!(#msg_target_id: message_vo.msg_target_id,
                                manager_id: message_vo.manager_id, # <= source of message (an application)
                                receiver_id: message_vo.receiver_id,
                                team_id: message_vo.team_id, # <= message coming from this team
                                email_subject: message_vo.email_subject,
                                email_message: message_vo.email_message,
                                email_options: message_vo.email_options,
                                template_id: message_vo.template_id,
                                sms_message: message_vo.sms_message)
      ReturnVo.new(value: message, error: nil)
    else
      ReturnVo.new(value: nil, error: return_error(message_vo.errors, :unprocessable_entity))
    end
  rescue StandardError => e
    handle_errors(e, message_vo)
  end

  def self.handle_errors(error, message_vo)
    msg = "Exception (#{error.message}) occurred in create_message for #{message_vo.to_json}"
    log_error(msg)
    ReturnVo.new(value: nil, error: return_error(msg, :unprocessable_entity))
  end
end
