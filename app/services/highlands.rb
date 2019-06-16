# frozen_string_literal: true

class Highlands
  # rubocop:disable all
  def self.link_highlands_msg_to_message(message_id, highlands_msg_id)
    highlands_msg = HighlandsMsg.find_by(id: highlands_msg_id)
    if highlands_msg.nil?
      log_error("Unable to find highlands_msg (#{highlands_msg_id}). Did not link message (#{message_id})")
      return false
    end
    message = Message.find_by(id: message_id)
    if message.nil?
      log_error("Unable to find message (#{message_id}). Did not link highlands_msg (#{highlands_msg_id})")
      return false
    end
    message.highlands_msg_id = highlands_msg_id
    message.save!
  end

  # def self.get_user(data)
  #   response = HighlandsClient::MessageClient.new(data: data[:highlands_data],
  #                                                   resource: 'messages').send_message
  #
  #   highlands_msg = HighlandsMsg.create!(sent_to_highlands: Time.now,
  #                                            response: { response: response['data'] })
  #
  #   highlands_msg.got_response_at = Time.now
  #   highlands_msg.status = response['data']['status']
  #
  #   if highlands_msg.save! && link_highlands_msg_to_message(data[:message_id], highlands_msg.id)
  #     return ReturnVo.new(value: return_accepted("highlands_msg": highlands_msg), error: nil)
  #   else
  #     err = highlands_msg.errors || "Error for highlands_id (#{highlands_id})"
  #     return ReturnVo.new(value: nil, error: return_error(err, :unprocessable_entity))
  #   end
  # end

  def get_user(data)
    data = data[:highlands_data]
    response = HighlandsClient::MessageClient.new(data: data,
                                                  resource: data[:resource]).get_user(data[:email])

    preferred_communications = response['data']['communications']['communication'].select{ |item| item['preferred'] == 'true' }
    mobile_communications = preferred_communications.select{ |item| item['communicationType']['name'] == 'Mobile'}
    email_communications = preferred_communications.select{ |item| item['communicationGeneralType'] == 'Email'}
    mobile_phones = mobile_communications.map{|item| item['communicationValue']}
    emails = email_communications.map{|item| item['communicationValue']}

    if !err.nil?
      msg = 'GET highlands user Error'
      return ReturnVo.new(value: nil, error: return_error(msg, :unprocessable_entity))
    else
      preferred_communications = {
          communications: {
              mobile_phones: mobile_phones,
              emails: emails
          }
      }
      return ReturnVo.new(value: return_accepted(preferred_communications: preferred_communications), error: nil)
    end

  end


  def self.get_user_by_email(email)
    # Populate and sanitize data
    data = {
            resource: 'search_by_email',
            email: email,
    }
    get_user(highlands_data: data)
  rescue StandardError => e
    err_msg = JSON.parse(e.message)['error']['message']
    err_msg = JSON.parse(e.message)['error']['msg'] if err_msg.nil?
    # Log Highlands subscription warnings if necessary. Note Uhura does not submit create_subscriber requests.
    if err_msg.include?('supplied subscribers is invalid') # "At least one of the supplied subscribers is invalid."
      # If the subscriber is invalid, let's assume that they've not been registered with Highlands.io
      # So, an entity outside of Uhura should create the subscriber see that they opt in before returning to Uhura.
      action_msg = {
        "error_from_highlands": err_msg,
        "assumed_meaning": "This receiver w/ mobile_number (#{message_vo.mobile_number}) not registered in Highlands",
        "action": "Research whether receiver_sso_id (#{message_vo.receiver_sso_id}) is valid."
      }
      log_warn(action_msg)
      err_msg = {
        "msg": err_msg,
        "action_required:": action_msg
      }
    elsif err_msg.include?('You must send your message to at least one subscriber')
      # Since Uhura does not submit subscription requests, this block should never be executed
      action_msg = {
        "error_from_highlands": err_msg,
        "action": "Research status of Highlands subscription for receiver_sso_id (#{message_vo.receiver_sso_id})"
      }
      log_warn(action_msg)
      err_msg = {
        "msg": err_msg,
        "action_required:": action_msg
      }
    end
    # Handle error in caller
    ReturnVo.new(value: nil, error: return_error(err_msg, :unprocessable_entity))
  end
  # rubocop:enable all
end
