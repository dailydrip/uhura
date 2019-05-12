class ApplicationController < ActionController::Base
  def flash_and_redirect(exception)
    flash[:error] = exception.message
    redirect_to root_path
  end


  def set_redirect_path
    session[:from] = params
  end
end
