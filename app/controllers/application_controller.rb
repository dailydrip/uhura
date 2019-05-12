class ApplicationController < ActionController::Base

  include HighlandsAuth::ApplicationHelper
  # protect_from_forgery with: :exception


  def flash_and_redirect(exception)
    flash[:error] = exception.message
    redirect_to root_path
  end

  def authenticate_admin!
    redirect_to auth.new_session_path unless current_user.try(:admin?)
  end

  def authenticate_user!
    redirect_to auth.new_session_path unless current_user
  end

  def set_redirect_path
    session[:from] = params
  end
end