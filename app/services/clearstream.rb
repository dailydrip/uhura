class Clearstream

  def self.link_clearstream_msg_to_message(message_id, clearstream_msg_id)
    clearstream_msg = ClearstreamMsg.find_by(id: clearstream_msg_id)
    if clearstream_msg.nil?
      log_error("Unable to find clearstream_msg (#{clearstream_msg_id}). Did not link message (#{message_id})")
      return false
    end
    message = Message.find_by(id: message_id)
    if message.nil?
      log_error("Unable to find message (#{message_id}). Did not link clearstream_msg (#{clearstream_msg_id})")
      return false
    end
    message.clearstream_msg_id = clearstream_msg_id
    message.save!
  end

  def self.send_msg(data)

    clearstream_msg = ClearstreamMsg.create!(sent_to_clearstream: Time.now,
                                             sms_json: data,
                                             clearstream_response: nil)

    cs_client = ClearstreamClient::MessageClient.new({data: data[:clearstream_data], resource: 'messages'})
    response = cs_client.create

    clearstream_msg.sms_json = response.to_json
    clearstream_msg.got_response_at = Time.now
    clearstream_msg.clearstream_response = response['data']['status']

    if clearstream_msg.save! && self.link_clearstream_msg_to_message(data[:message_id], clearstream_msg.id)
      return ReturnVo.new({value: return_accepted({"clearstream_msg": clearstream_msg.to_json}), error: nil})
    else
      err = clearstream_msg.errors || "Error for clearstream_id (#{clearstream_id})"
      return ReturnVo.new({value: nil, error: return_error(err, :unprocessable_entity)})
    end
  end


  def self.create_subscriber(data)
    new_subscriber_data = {
        'mobile_number': data[:mobile_number],
        'first': data[:first_name],
        'last': data[:last_name],
        'email': data[:receiver_email],
        'lists': data[:lists],
        'autoresponse_header': 'Higlands SMS',
        'autoresponse_body': 'Your SMS Opt-in setting has been updated.'
    }
    cs_client = ClearstreamClient::MessageClient.new({data: new_subscriber_data, resource: 'subscribers'})
    response = cs_client.create
    msg = "Requested Clearstream to create subscriber (#{new_subscriber_data.to_json}). Got response (#{response.to_json})"
    log_info(msg)
    #TODO: Verify that this status is correct when Clearstream.io support increases subscriber limit
    if response['data']['status'] == 'QUEUED'
      return ReturnVo.new({value: return_accepted({"clearstream_msg": clearstream_msg.to_json}), error: nil})
    else
      err = "Failed to create subscriber. Clearstream response: #{response.to_json}"
      return ReturnVo.new({value: nil, error: return_error(err, :unprocessable_entity)})
    end
  end

  def self.send(message_vo)
    # Populate and sanitize data
    data = ClearstreamSmsVo.new(
        receiver_sso_id: message_vo.receiver_sso_id,
        team_name: message_vo.team_name,
        sms_message: message_vo.sms_message,
        message_id: message_vo.message_id
    ).get()

    send_msg({clearstream_data: data, message_id: message_vo.message_id})

  rescue StandardError => err

    err_msg = JSON.parse(err.message)['error']['message']
    log_error(err_msg)
    if err_msg.include?('supplied subscribers is invalid')
      # If the subscriber is invalid, let's assume that they've not been registered with Clearstream.io
      # So, we'll create the subscriber and after the receiver opts-in we'll resend the message.

      # Wait for subscriber to opt in, then...  Q: Clearstream support: How do we know when a user opts in?
      # Ideally, get user-opted-in event hook and run submit_sms for that newly opted-in user
      create_subscriber(data)
      #TODO: Add resend message after user opts-in
    end

    msg = "Clearstream.send error: #{err.message}, for #{message_vo.to_json}"
    log_error(msg)
    return ReturnVo.new({value: nil, error: error_json = return_error(msg, :unprocessable_entity)})
  end
end
