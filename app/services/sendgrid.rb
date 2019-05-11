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

    data = SendgridMailVo.new(
        from: message_vo.manager_email,
        to:  message_vo.receiver_email,
        template_id: message_vo.template_id,
        dynamic_template_data: template_data
    )
    sendgrid_msg = SendgridMsg.create!(sent_to_sendgrid: Time.now,
                                       mail_json: data,
                                       got_response_at: nil,
                                       sendgrid_response: nil,
                                       read_by_user_at: nil)

    response = sg.client.mail._("send").post(request_body: JSON.parse(data.get.to_json))

    rsc = response.status_code
    sendgrid_msg.got_response_at = Time.now
    sendgrid_msg.sendgrid_response = rsc

    if sendgrid_msg.save! && self.link_sendgrid_msg_to_message(message_vo.message_id,  sendgrid_msg.id)
      return ReturnVo.new({value: return_success(sendgrid_msg), error: nil})
    else
      err = sendgrid_msg.errors || "Error for sendgrid_id (#{sendgrid_id})"
      return ReturnVo.new({value: nil, error: error_json = return_error(err, :unprocessable_entity)})
    end
  rescue StandardError => err
    msg = "send_via_sendgrid: #{err.message}"
    log_error(msg)
    return ReturnVo.new({value: nil, error: error_json = return_error(msg, :unprocessable_entity)})
  end

  private

  def mail(message_vo)
    # Got valid input
    from = SendGrid::Email.new(email: message_vo.app.email)
    to = SendGrid::Email.new(email: message_vo.receiver)
    subject = message_vo.email_subject
    content = SendGrid::Content.new(
        type: 'text/plain',
        value: message_vo.email_content
    )
    SendGrid::Mail.new(from, subject, to, content)
  end
end
