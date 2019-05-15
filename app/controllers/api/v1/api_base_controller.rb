class Api::V1::ApiBaseController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :verify_auth_token
  before_action :set_manager
  before_action :set_team_name

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

  def set_team_name
    team_name = request.headers['X-Team-ID']
    team = Team.find_by(name: team_name)
    if team.nil?
      msg = "Team name (X-Team-ID HTTP header) #{team_name} NOT found!"
      log_error(msg)
      render json: return_error(msg)
    else
      @team_name = team.name
    end
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
