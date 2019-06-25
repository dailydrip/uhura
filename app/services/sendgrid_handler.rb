# frozen_string_literal: true

class SendgridHandler < ServiceHandlerBase
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
    sendgrid_vo = deep_symbolize_keys_if_needed(sendgrid_vo)
    message_id = sendgrid_vo[:message_id]
    mail_obj = SendgridMailVo.mail(sendgrid_vo[:mail_vo])

    sendgrid_msg = find_sendgrid_msg_and_update_it(mail_obj, sendgrid_vo)

    link_message_record_to_sendgrid_msg_record_and_return_it(sendgrid_msg, message_id)
  end

  def self.find_sendgrid_msg_and_update_it(mail_obj, sendgrid_vo)
    # Request Clearstream client to send message
    sent_to_sendgrid_at = Time.now
    response_and_mail = SendgridMailer.new.send_email(mail_obj)
    response = response_and_mail[:response]
    mail = response_and_mail[:mail]

    uhura_msg_id = sendgrid_vo[:mail_vo][:personalizations][0][:custom_args][:uhura_msg_id]
    # body attribute will be populated if there's an error.
    # An empty body from Sendgrid could indicate a message "Not Delivered" status from Sendgrid or success
    sendgrid_msg = SendgridMsg.find_by(id: uhura_msg_id)
    sendgrid_msg.update!(sent_to_sendgrid: sent_to_sendgrid_at,
                         mail_and_response: { mail: mail.to_json, response: response },
                         got_response_at: Time.now,
                         sendgrid_response: response[:status_code])
    sendgrid_msg
  end

  def self.deep_symbolize_keys_if_needed(sendgrid_vo)
    if sendgrid_vo[:mail_vo].blank?
      log_warn('Sidekiq performs a deep_stringify_keys on the hash; reverse that with deep_symbolize_keys.')
      sendgrid_vo.deep_symbolize_keys
    else
      sendgrid_vo
    end
  end

  def self.link_message_record_to_sendgrid_msg_record_and_return_it(sendgrid_msg, message_id)
    # Link message record to sendgrid_msg record
    if sendgrid_msg.save! && link_sendgrid_msg_to_message(message_id, sendgrid_msg.id)
      ReturnVo.new_value(sendgrid_msg: sendgrid_msg)
    else
      ReturnVo.new_err(sendgrid_msg.errors || "Error for sendgrid_id (#{sendgrid_id})")
    end
  end

  def self.send(message_vo)
    template_data = message_vo.email_message
    template_data['email_subject'] = message_vo.email_subject

    sendgrid_vo = populate_required_attributes_for_request(message_vo, template_data)

    # SendgridHandler.send_msg(sendgrid_vo)
    SendSendgridMessageWorker.perform_async(sendgrid_vo)

    msg = "Asynchronously sent Email: (#{message_vo.team_name}:#{message_vo.email_subject}) "
    msg += "from (#{message_vo.manager_name}) to (#{message_vo.email} <#{message_vo.first} #{message_vo.last}>)"
    log_info(msg)
    ReturnVo.new(value: return_accepted(sendgrid_msg: msg), error: nil)
  rescue StandardError => e
    err_msg = get_err_msg(e)
    handle_sendgrid_msg_error(err_msg, sendgrid_vo, message_vo)
  end

  def self.handle_sendgrid_msg_error(err_msg, sendgrid_vo, message_vo)
    # A error occurs while processing the request. Record ERROR status.
    sendgrid_msg = SendgridMsg.create!(
      mail_and_response: { mail: sendgrid_vo[:mail].to_json, response: { error: err_msg } },
      status: 'ERROR'
    )
    # Link sendgrid_msg to message
    message = Message.find(message_vo.message_id)
    message.sendgrid_msg = sendgrid_msg
    message.save!
    ReturnVo.new_err(err_msg)
  end

  def self.populate_required_attributes_for_request(message_vo, template_data)
    sendgrid_msg_on_uhura = SendgridMsg.create
    SendgridMailVo.new(
      from: message_vo.manager_email,
      subject: message_vo.email_subject,
      receiver_sso_id: message_vo.receiver_sso_id,
      template_id: message_vo.sendgrid_template_id,
      dynamic_template_data: template_data,
      email_options: message_vo.email_options,
      personalizations: [
        {
          custom_args: { uhura_msg_id: sendgrid_msg_on_uhura.id }
        }
      ],
      message_id: message_vo.message_id
    ).vo
  end
end
