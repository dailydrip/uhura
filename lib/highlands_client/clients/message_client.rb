# frozen_string_literal: true

module HighlandsClient
  # rubocop:disable all
  class MessageClient < BaseClient
    alias get_user search_by_email
    alias get_receiver user_preferences

    def self.create_subscriber(data)
      new_subscriber_data = {
        'mobile_number': data.mobile_number,
        'first': data.first,
        'last': data.last,
        'email': data.receiver_email,
        'lists': data.lists,
        'autoresponse_header': 'Higlands SMS',
        'autoresponse_body': 'Your SMS Opt-in setting has been updated.'
      }
      base_client = HighlandsClient::BaseClient.new(data: new_subscriber_data, resource: 'subscribers')
      begin
        response = base_client.create
      rescue APIError => e
        msg = "Failed to create subscriber. Highlands response: #{response.to_json}. APIError: #{e.message}"
        log_error(msg)
        return ReturnVo.new(value: nil, error: return_error(msg, :unprocessable_entity))
      end
      msg = "Requested Highlands to create subscriber (#{new_subscriber_data.to_json}). Resonse: #{response.to_json}"
      log_info(msg)
      if response['data']['status'] == 'QUEUED'
        return ReturnVo.new(value: return_accepted("highlands_msg": highlands_msg.to_json), error: nil)
      else
        msg = "Failed to create subscriber. Highlands response: #{response.to_json}"
        log_error(msg)
        return ReturnVo.new(value: nil, error: return_error(msg, :unprocessable_entity))
      end
    end
  end
end
