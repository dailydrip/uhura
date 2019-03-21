# frozen_string_literal: true

module ControllerSpecHelper
  # return valid headers
  def valid_headers
    {
      'Authorization' => 'Basic ' + Base64.encode64("#{Rails.application.credentials.basic_auth[:admin_name]}:#{Rails.application.credentials.basic_auth[:admin_password]}"),
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
