# frozen_string_literal: true

module ControllerSpecHelper

  # return valid headers
  def valid_headers
    {
      'Authorization' => 'Bearer ' + ApiKey.first.auth_token,
      'Content-Type' => 'application/json',
      'X-Team-ID' => Team.first.name
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
