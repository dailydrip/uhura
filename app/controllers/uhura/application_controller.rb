# All Administrate controllers inherit from this `Admin::ApplicationController`,
# making it the ideal place to put authentication logic or other
# before_actions.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Uhura
  class ApplicationController < Administrate::ApplicationController
    include HighlandsAuth::ApplicationHelper
    before_action :authenticate_admin!
    protect_from_forgery with: :exception

    def authenticate_admin!
      redirect_to auth.new_session_path unless current_user
    end



    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end
  end
end
