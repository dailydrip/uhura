# frozen_string_literal: true

class SendgridHandler < ServiceHandlerBase
  # rubocop:disable all
  def self.link_sendgrid_msg_to_message(message_id, sendgrid_msg_id)
    sendgrid_msg = SendgridMsg.find_by(id: sendgrid_msg_id)
    if sendgrid_msg.nil?
      log_error("Unable to find sendgrid_msg (#{sendgrid_msg_id}). Did not link message (#{message_id})")
      return false
    end
    message = Message.find_by(id: message_id)
    if message.nil?
      log_error("Unable to find message (#{message_id}). Did not link sendgrid_msg (#{sendgrid_msg_id})")
      return false
    end
    message.sendgrid_msg_id = sendgrid_msg_id
    message.save!
  end

  def self.send_msg(sendgrid_vo)
    if sendgrid_vo[:mail_vo].blank?
      log_warn('Sidekiq performs a deep_stringify_keys on the hash; reverse that with deep_symbolize_keys.')
      sendgrid_vo = sendgrid_vo.deep_symbolize_keys
    end
    message_id = sendgrid_vo[:message_id]
    mail_obj = SendgridMailVo.get_mail(sendgrid_vo[:mail_vo])
    # Request Clearstream client to send message
    response_and_mail = SendgridMailer.new.send_email(mail_obj)
    response = response_and_mail[:response]
    mail = response_and_mail[:mail]
    # Record date Sendgrid server said they got the message. body attribute will be populated if there's an error.
    # An empty body from Sendgrid could indicate a message "Not Delivered" status from Sendgrid
    log_warn("Received empty body from Sengdrid for messsage_id (#{message_id})") if response[:body].blank?
    # Record Clearstream response.
    sendgrid_msg = SendgridMsg.create!(sent_to_sendgrid: Time.now,
                                       x_message_id: response_and_mail[:response][:x_message_id],
                                       mail_and_response: { mail: mail.to_json, response: response },
                                       got_response_at: nil,
                                       sendgrid_response: nil,
                                       read_by_user_at: nil)
    sendgrid_msg.got_response_at = Time.now
    sendgrid_msg.sendgrid_response = response[:status_code]
    # Link message record to sendgrid_msg record

    if sendgrid_msg.save! && link_sendgrid_msg_to_message(message_id, sendgrid_msg.id)
      return ReturnVo.new_value(sendgrid_msg: sendgrid_msg)
    else
      return ReturnVo.new_err(sendgrid_msg.errors || "Error for sendgrid_id (#{sendgrid_id})")
    end
  end

  def self.send(message_vo)
    template_data = message_vo.email_message
    template_data['email_subject'] = message_vo.email_subject
    # Populate attributes required for request
    sendgrid_vo = SendgridMailVo.new(
        from: message_vo.manager_email,
        subject: message_vo.email_subject,
        receiver_sso_id: message_vo.receiver_sso_id,
        template_id: message_vo.sendgrid_template_id,
        dynamic_template_data: template_data,
        email_options: message_vo.email_options,
        message_id: message_vo.message_id
    ).get_vo

    #SendgridHandler.send_msg(sendgrid_vo)
    SendSendgridMessageWorker.perform_async(sendgrid_vo)

    msg = "Asynchronously sent SMS: (#{message_vo.team_name}:#{message_vo.email_subject}) "
    msg += "from (#{message_vo.manager_name}) to (#{message_vo.mobile_number})"
    log_info(msg)
    return ReturnVo.new(value: return_accepted("clearstream_msg": msg), error: nil)

  rescue StandardError => e
    err_msg = self.get_err_msg(e)
    # A error occurs while processing the request. Record ERROR status.
    sendgrid_msg = SendgridMsg.create!(
        mail_and_response: { mail: sendgrid_vo[:mail].to_json, response: { error: err_msg } },
        status: 'ERROR')
    # Link sendgrid_msg to message
    message = Message.find(message_vo.message_id)
    message.sendgrid_msg = sendgrid_msg
    message.save!
    ReturnVo.new_err(err_msg)
  end
  # rubocop:enable all
end
