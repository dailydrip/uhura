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
    response_and_mail = SendgridMailer.new.send_email(message_vo) # .deliver_later
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
      return ReturnVo.new(value: return_accepted("sendgrid_msg": sendgrid_msg), error: nil)
    else
      err = sendgrid_msg.errors || "Error for sendgrid_id (#{sendgrid_id})"
      return ReturnVo.new(value: nil, error: return_error(err, :unprocessable_entity))
    end
  rescue StandardError => e
    msg = "Sendgrid.send Error: #{e.message}"
    log_error(msg)
    ReturnVo.new(value: nil, error: return_error(msg, :unprocessable_entity))
  end
end
