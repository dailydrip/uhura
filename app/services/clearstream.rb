class Clearstream

  def self.link_clearstream_msg_to_message(message_id, clearstream_msg_id)
    message = Message.find_by(id: message_id)
    if message.nil?
      log_error("Unable to find message (#{message_id}) for clearstream_id (#{clearstream_msg_id})")
    end
    message
  end

  def self.send(message_vo)

    body = {
        "template_id=": "Blue Sushi",
        "message_body": "Come in now for 50% off all rolls!",
        "lists": "1,2"
    }

    data = SendgridMailVo.new(
        from: message_vo.manager_email,
        to:  message_vo.receiver_email,
        template_id: message_vo.template_id,
        dynamic_template_data: template_data
    )

    token = ENV['CLEARSTREAM_KEY']
    uri = "#{ENV['CLEARSTREAM_URL']}/messages"
    cs_request = Request.new(token: token, uri: uri, verb: :post, body: body)


    cs_message = ClearstreamClient::Message.new(params)
    if !cs_message.valid?
      error_json = return_error(cs_message.errors)
      render json: error_json, status: 422 # Unprocessable Entity
    else
      # Send message and render app/views/api/v1/messages/create.json.jbuilder view
      ClearstreamClient::MessageClient.new(
          data: cs_message,
          resource: RESOURCE
      ).create
    end



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
    clearstream_msg = SendgridMsg.create!(sent_to_clearstream: Time.now,
                                       mail_json: data,
                                       got_response_at: nil,
                                       clearstream_response: nil,
                                       read_by_user_at: nil)

    response = sg.client.mail._("send").post(request_body: JSON.parse(data.get.to_json))

    rsc = response.status_code
    clearstream_msg.got_response_at = Time.now
    clearstream_msg.clearstream_response = rsc

    if clearstream_msg.save! && self.link_clearstream_msg_to_message(message_vo.message_id,  clearstream_msg.id)
      return ReturnVo.new({value: clearstream_msg, error: nil})
    else
      err = clearstream_msg.errors || "Error for clearstream_id (#{clearstream_id})"
      return ReturnVo.new({value: nil, error: error_json = return_error(err, :unprocessable_entity)})
    end
  rescue StandardError => err
    msg = "send_via_clearstream: #{err.message}"
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
