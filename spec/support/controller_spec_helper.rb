# frozen_string_literal: true

module ControllerSpecHelper
  # return valid headers
  def valid_headers
    {
      'Authorization' => 'Token token=' + Base64.encode64("#{AppCfg['TOKEN_AUTH_USER']}:#{AppCfg['TOKEN_AUTH_PASSWORD']}").strip,
      'Content-Type' => 'application/json'
    }
  end

  # return invalid headers
  def invalid_headers
    {
      'Authorization' => nil,
      'Content-Type' => nil
    }
  end
end
