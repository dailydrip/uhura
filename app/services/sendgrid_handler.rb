# frozen_string_literal: true

class SendgridHandler < ServiceHandlerBase
  def self.send(message_vo)
    template_data = message_vo.email_message
    template_data['subject'] = message_vo.email_subject # Must use 'subject' for Sendgrid template

    sendgrid_vo = create_sendgrid_msg(message_vo, template_data)

    SendgridMessageWorker.perform_async(sendgrid_vo)

    msg = "Asynchronously sent email: (#{message_vo.team_name}:#{message_vo.email_subject}) "
    msg += "from (#{message_vo.manager_name}) to (#{message_vo.email} <#{message_vo.first} #{message_vo.last}>)"
    log_info(msg)
    ReturnVo.new(value: return_accepted(sendgrid_msg: msg), error: nil)
  rescue StandardError => e
    err_msg = get_err_msg(e)
    handle_sendgrid_msg_error(err_msg, sendgrid_vo, message_vo)
  end

  def self.create_sendgrid_msg(message_vo, template_data)
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

  def self.handle_sendgrid_msg_error(err_msg, sendgrid_vo, message_vo)
    log_error(err_msg)
    # A error occurs while processing the request. Record ERROR status.
    sendgrid_msg = SendgridMsg.create!(
      mail_and_response: {
        mail: sendgrid_vo[:mail].to_json,
        response: { error: err_msg }
      },
      status: 'ERROR'
    )
    # Link sendgrid_msg to message
    message = Message.find(message_vo.message_id)
    message.sendgrid_msg = sendgrid_msg
    message.save!
    ReturnVo.new_err(err_msg)
  end

  # Called from SendgridMessageWorker
  def self.send_msg(sendgrid_vo)
    sendgrid_vo = deep_symbolize_keys_if_needed(sendgrid_vo)
    message_id = sendgrid_vo[:message_id]
    mail_obj = SendgridMailVo.mail(sendgrid_vo[:mail_vo])
    sendgrid_msg = send_email_and_update_sendgrid_msg(mail_obj, sendgrid_vo)
    save_and_link_message(sendgrid_msg, message_id)
  end

  def self.deep_symbolize_keys_if_needed(sendgrid_vo)
    return sendgrid_vo if sendgrid_vo[:mail_vo].present?

    log_warn('Sidekiq performs a deep_stringify_keys on the hash; reverse that with deep_symbolize_keys.')
    sendgrid_vo.deep_symbolize_keys
  end

  def self.send_email_and_update_sendgrid_msg(mail_obj, sendgrid_vo)
    # Request Clearstream client to send message
    sent_to_sendgrid_at = Time.current
    response_and_mail = SendgridMailer.new.send_email(mail_obj)
    response = response_and_mail[:response]
    mail = response_and_mail[:mail]

    uhura_msg_id = sendgrid_vo[:mail_vo][:personalizations][0][:custom_args][:uhura_msg_id]
    # body attribute will be populated if there's an error.
    # An empty body from Sendgrid could indicate a message "Not Delivered" status from Sendgrid or success
    sendgrid_msg = SendgridMsg.find_by(id: uhura_msg_id)
    sendgrid_msg.update!(
      sent_to_sendgrid: sent_to_sendgrid_at,
      mail_and_response: {
        mail: mail.to_json,
        response: response
      },
      got_response_at: Time.current,
      sendgrid_response: response[:status_code] || response['status_code']
    )
    sendgrid_msg
  end

  def self.save_and_link_message(sendgrid_msg, message_id)
    # Link message record to sendgrid_msg record
    if sendgrid_msg.save! && link_sendgrid_msg_to_message(message_id, sendgrid_msg.id)
      log_info("Successfully linked sendgrid_msg.id #{sendgrid_msg.id} to message_id #{message_id}")
    else
      log_error("Error linking sendgrid_msg.id #{sendgrid_msg.id} to message_id #{message_id} - #{sendgrid_msg.errors}")
    end
  end

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
end
