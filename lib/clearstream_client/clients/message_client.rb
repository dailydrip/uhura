# frozen_string_literal: true

module ClearstreamClient
  class MessageClient < BaseClient

    alias_method :send_message, :create

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

      base_client = ClearstreamClient::BaseClient.new({data: new_subscriber_data, resource: 'subscribers'})
      begin
        response = base_client.create
      rescue APIError => error
        msg = "Failed to create subscriber. Clearstream response: #{response.to_json}"
        log_error(msg)
        return ReturnVo.new({value: nil, error: return_error(msg, :unprocessable_entity)})
      end
      msg = "Requested Clearstream to create subscriber (#{new_subscriber_data.to_json}). Got response (#{response.to_json})"
      log_info(msg)
      #TODO: Verify that this status is correct when Clearstream.io support increases subscriber limit
      if response['data']['status'] == 'QUEUED'
        return ReturnVo.new({value: return_accepted({"clearstream_msg": clearstream_msg.to_json}), error: nil})
      else
        msg = "Failed to create subscriber. Clearstream response: #{response.to_json}"
        log_error(msg)
        return ReturnVo.new({value: nil, error: return_error(msg, :unprocessable_entity)})
      end
    end

  end
end
