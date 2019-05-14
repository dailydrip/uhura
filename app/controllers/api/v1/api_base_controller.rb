class Api::V1::ApiBaseController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :verify_auth_token
  before_action :set_manager
  before_action :set_team

  protected

  def set_manager
    session[:public_token] = params[:public_token] if params[:public_token]
    @manager = Manager.find_by(public_token: session[:public_token]) if session[:public_token]
    if @manager.nil?
      msg = "Manager with public_token (#{params[:public_token]}) NOT found!"
      log_error(msg)
      render json: return_error(msg)
    end
  end

  def set_team
    x_team_header = request.headers['X-Team-ID']
    @team = x_team_header if Team.find_by(x_team_id: x_team_header)
  end

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
