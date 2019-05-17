# frozen_string_literal: true

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
      render json: return_error(msg), status: :unprocessable_entity
    end
  end

  def set_team_name
    team_name = request.headers['X-Team-ID']
    err_msg = nil
    if team_name.nil? || team_name.strip.size.eql?(0)
      err_msg = 'Required HTTP header (X-Team-ID) is missing.'
    else
      team = Team.find_by(name: team_name)
      if team.nil?
        err_msg = "Team name (#{team_name}) from the X-Team-ID HTTP header NOT found! "
        err_msg += "Consider adding Team name (#{team_name}) using the Admin app on the Teams page."
      else
        @team_name = team.name
      end
    end
    if err_msg
      log_error(err_msg)
      render json: return_error(err_msg), status: :unprocessable_entity
    end
  end

  def verify_auth_token
    authorization_header = request.headers['Authorization']
    api_key =  authorization_header.gsub('Bearer ', '').strip if authorization_header

    @manager = ApiKey.find_by(auth_token: api_key).try(:manager)
    unauthenticated_request unless @manager
  end

  def unauthenticated_request
    msg = 'This API Key does not exist.'
    log_error(msg)
    render json: return_error(msg), status: :unauthorized
  end
end
