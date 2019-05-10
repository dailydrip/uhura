class ApplicationController < ActionController::Base
  # include HighlandsAuth::ApplicationHelper
  protect_from_forgery with: :exception

  before_action :set_manager

  def flash_and_redirect(exception)
    flash[:error] = exception.message
    if @invoice
      redirect_to_invoice_path
    else
      redirect_to root_path
    end
  end

  def authenticate_admin!
    redirect_to auth.new_session_path unless current_user.try(:admin?)
  end

  def authenticate_user!
    redirect_to auth.new_session_path unless current_user
  end

  def redirect_to_checkout_path
    redirect_to new_checkout_path(offer_id: @offer)
  end

  def redirect_to_invoice_path
    redirect_to invoice_path(@invoice)
  end

  def set_manager
    session[:public_token] = params[:public_token] if params[:public_token]
    @manager = Manager.find_by(public_token: session[:public_token]) if session[:public_token]
    if @manager.nil?
      msg = "Manager with public_token (#{params[:public_token]}) NOT found!"
      log_error(msg)
      render json: return_error(msg)
    end
  end

  def set_redirect_path
    session[:from] = params
  end
end