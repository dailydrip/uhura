# frozen_string_literal: true

class Sendgrid
  # rubocop:disable Metrics/MethodLength
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

  # rubocop:disable all
  def self.send(message_vo)
    # Execute Sendgrid request
    response_and_mail = SendgridMailer.new.send_email(message_vo)
    response = response_and_mail[:response]
    mail = response_and_mail[:mail]
    # Record date Sendgrid server said they got the message. body attribute will be populated if there's an error.
    trimmed_response = {
      date: response&.headers['date'] ? response.headers['date'][0] : '',
      body: response&.body
    }
    # Record time message sent to Sendgrid. Later, populate with response time.
    sendgrid_msg = SendgridMsg.create!(sent_to_sendgrid: Time.now,
                                       mail_and_response: { mail: mail.to_json, response: trimmed_response },
                                       got_response_at: nil,
                                       sendgrid_response: nil,
                                       read_by_user_at: nil)
    sendgrid_msg.got_response_at = Time.now
    sendgrid_msg.sendgrid_response = response.status_code
    # Link message record to sendgrid_msg record
    if sendgrid_msg.save! && link_sendgrid_msg_to_message(message_vo.message_id, sendgrid_msg.id)
      return ReturnVo.new_value({sendgrid_msg: sendgrid_msg})
    else
      err = sendgrid_msg.errors || "Error for sendgrid_id (#{sendgrid_id})"
      return ReturnVo.new_err(err_msg)
    end
  rescue StandardError => e
    err_msg = JSON.parse(e.message)['error']['msg'] if err_msg.nil?
    log_error(err_msg)
    # A error occurs while processing the request. Record ERROR status.
    sendgrid_msg = SendgridMsg.create!(
        mail_and_response: { mail: mail.to_json, response: { error: err_msg } },
        status: 'ERROR')
    # Link sendgrid_msg to message
    message = Message.find(message_vo.message_id)
    message.sendgrid_msg = sendgrid_msg
    message.save!
    ReturnVo.new_err(err_msg)
  end
end
