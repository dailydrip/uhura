class ServiceHandlerBase
  def self.get_err_msg(e)
    begin
      err_msg = JSON.parse(e.message)['error']['message']
    rescue JSON::ParserError
      err_msg = e.message
    rescue StandardError
      err_msg = e.to_s
    end
    log_error(err_msg)
    err_msg
  end
end
