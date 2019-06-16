# frozen_string_literal: true

class ServiceHandlerBase
  def self.get_err_msg(error)
    begin
      err_msg = JSON.parse(error.message)['error']['message']
    rescue JSON::ParserError
      err_msg = error.message
    rescue StandardError
      err_msg = error.to_s
    end
    log_error(err_msg)
    err_msg
  end
end
