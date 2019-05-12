class HomeController < ApplicationController

  include HighlandsAuth::ApplicationHelper

  before_action :authenticate_admin!

  def authenticate_admin!
    redirect_to auth.new_session_path
  end

  def index
  end
end
