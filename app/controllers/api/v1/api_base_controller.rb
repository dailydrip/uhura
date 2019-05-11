class Api::V1::ApiBaseController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :verify_auth_token

  protected

  def verify_auth_token
    authorization_header = request.headers['Authorization']
    api_key =  authorization_header.gsub('Bearer ', '').strip if authorization_header

    @manager = ApiKey.find_by(auth_token: api_key).try(:manager)
    unauthenticated_request unless @manager
  end

  def unauthenticated_request
    render json: { error: 'This Api Key does not exist.' }, status: :unauthorized
  end
end