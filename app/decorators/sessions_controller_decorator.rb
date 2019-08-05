# frozen_string_literal: true

HighlandsAuth::SessionsController.class_eval do
  private

  def redirect_user
    redirect_to AppCfg['ADMIN_PATH']
  end

  def after_update_user
    email = params[:user][:username]
    user = User.find_by(email: email)
    if user
      # if you want to do something after finding the user, do it here
    else
      User.create(email: email)
    end
  end
end
