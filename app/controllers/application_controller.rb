# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_on_staging

  def authenticate_on_staging
    if Rails.env == 'test'
      http_basic_authenticate_or_request_with(
        name: Rails.application.credentials.basic_auth[:admin_name],
        password: Rails.application.credentials.basic_auth[:admin_password]
      )
    end
  end
end
