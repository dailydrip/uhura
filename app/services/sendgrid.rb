# frozen_string_literal: true

class Sendgrid
  def self.link_sendgrid_msg_to_message(message_id, sendgrid_msg_id)
    sendgrid_msg = SendgridMsg.find_by(id: sendgrid_msg_id)
    if sendgrid_msg.nil?
      log_error("Unable to find sendgrid_msg (#{sendgrid_msg_id}). Did not link message (#{message_id})")
      return false
    end
    message = Message.find_by(id: message_id)
    if sendgrid_msg.nil?
      log_error("Unable to find message (#{message_id}). Did not link sendgrid_msg (#{sendgrid_msg_id})")
      return false
    end
    message.sendgrid_msg_id = sendgrid_msg_id
  end

  def self.send(message_vo)
    # Get a new API Client to send the new email
    sg = SendGrid::API.new(api_key: AppCfg['SENDGRID_API_KEY'])

    template_data = message_vo.email_message
    template_data['email_subject'] = message_vo.email_subject

    mail = SendgridMail.new(
      from: message_vo.manager_email,
      subject: message_vo.email_subject,
      receiver_sso_id: message_vo.receiver_sso_id,
      template_id: message_vo.template_id,
      dynamic_template_data: template_data
    ).get

    response = sg.client.mail._('send').post(request_body: mail.to_json)

    trimmed_response = {
      date: response.headers && response.headers['date'] ? response.headers['date'][0] : '',
      x_message_id: response.headers && response.headers['x-message-id'] ? response.headers['x-message-id'][0] : ''
    }

    sendgrid_msg = SendgridMsg.create!(sent_to_sendgrid: Time.now,
                                       mail_and_response: { mail: mail.to_json, response: trimmed_response },
                                       got_response_at: nil,
                                       sendgrid_response: nil,
                                       read_by_user_at: nil)
    rsc = response.status_code
    sendgrid_msg.got_response_at = Time.now
    sendgrid_msg.sendgrid_response = rsc

    if sendgrid_msg.save! && link_sendgrid_msg_to_message(message_vo.message_id, sendgrid_msg.id)
      return ReturnVo.new(value: return_accepted("sendgrid_msg": sendgrid_msg.to_json), error: nil)
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
