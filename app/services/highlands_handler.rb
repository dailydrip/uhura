# frozen_string_literal: true

class HighlandsHandler < ServiceHandlerBase
  # This is a synchronous call
  def get_user_preferences(data)
    data = data[:highlands_data]
    response = HighlandsClient::MessageClient.new(
      data: data,
      resource: data[:resource]
    ).get_user_preferences(data[:id])
    preferences = Receiver.convert_preferences(response['preferences'])
    return ReturnVo.new_value(clearstream_msg: clearstream_msg) if preferences.present?
    return ReturnVo.new_err(clearstream_msg.errors || "No user_preferences found for id (#{data[:id]})")
  end
end
