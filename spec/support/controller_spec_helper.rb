# frozen_string_literal: true

module ControllerSpecHelper
  def valid_headers
    {
      'Authorization' => 'Bearer ' + ApiKey.first.auth_token,
      'Content-Type' => 'application/json',
      'X-Team-ID' => Team.first.id.to_s
    }
  end

  def invalid_headers
    {
      'Authorization' => nil,
      'Content-Type' => nil
    }
  end
end
