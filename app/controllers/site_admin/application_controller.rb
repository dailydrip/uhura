# frozen_string_literal: true

# All Administrate controllers inherit from this `Admin::ApplicationController`,
# making it the ideal place to put authentication logic or other
# before_actions.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module SiteAdmin
  class ApplicationController < Administrate::ApplicationController
    include HighlandsAuth::ApplicationHelper
    protect_from_forgery with: :exception
    before_action :authenticate_user!
    before_action :authenticate_admin

    def authenticate_user!
      redirect_to auth.new_session_path unless current_user
    end

    def authenticate_admin
      redirect_to '/', alert: 'You are not authorized to access the admin application.' unless current_user&.admin?
    end
  end
end
