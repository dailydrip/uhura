# frozen_string_literal: true

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
    response = ClearstreamClient::MessageClient.new(data: data[:clearstream_data],
                                                    resource: 'messages').send_message

    clearstream_msg = ClearstreamMsg.create!(sent_to_clearstream: Time.now,
                                             response: { response: response['data'] })

    clearstream_msg.got_response_at = Time.now
    clearstream_msg.status = response['data']['status']

    if clearstream_msg.save! && link_clearstream_msg_to_message(data[:message_id], clearstream_msg.id)
      return ReturnVo.new(value: return_accepted("clearstream_msg": clearstream_msg.to_json), error: nil)
    else
      err = clearstream_msg.errors || "Error for clearstream_id (#{clearstream_id})"
      return ReturnVo.new(value: nil, error: return_error(err, :unprocessable_entity))
    end
  end

  def self.send(message_vo)
    # Populate and sanitize data
    data = ClearstreamSmsVo.new(
      receiver_sso_id: message_vo.receiver_sso_id,
      team_name: message_vo.team_name,
      sms_message: message_vo.sms_message,
      message_id: message_vo.message_id
    ).get

    send_msg(clearstream_data: data, message_id: message_vo.message_id)
  rescue StandardError => e
    err_msg = JSON.parse(e.message)['error']['message']
    if err_msg.include?('supplied subscribers is invalid') # "At least one of the supplied subscribers is invalid."
      # If the subscriber is invalid, let's assume that they've not been registered with Clearstream.io
      # So, we'll create the subscriber and after the receiver opts-in we'll resend the message.

      # Wait for subscriber to opt in, then...  Q: Clearstream support: How do we know when a user opts in?
      # Ideally, get user-opted-in event hook and run submit_sms for that newly opted-in user
      msg_json = {
        "error_from_clearstrem": err_msg,
        "assumed_meaning": 'This receiver has not been registered in Clearstream',
        "action": "Sending request to Clearsream to create a new subscriber for mobile_number (#{message_vo.mobile_number})"
      }.to_json
      log_warning(msg_json)
      ClearstreamClient::MessageClient.create_subscriber(message_vo)
      # TODO: Add resend message after user opts-in
      #
    elsif err_msg.include?('You must send your message to at least one subscriber')
      msg_json = {
        "error_from_clearstrem": err_msg,
        "assumed_meaning": "A Clearstream subscription request has been sent to this mobile_phone (#{message_vo.mobile_number})",
        "action": 'None.'
      }.to_json
      log_warning(msg_json)
    end
    # Handle error in caller
    ReturnVo.new(value: nil, error: return_error(err_msg, :unprocessable_entity))
  end
end
