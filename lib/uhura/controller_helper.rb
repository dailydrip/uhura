# frozen_string_literal: true

module ControllerHelper
  def env_var(env_var_name)
    ENV[env_var_name] || missing_env_var(env_var_name)
  end

  private

  def missing_env_var(env_var_name)
    # Log missing env var
    puts "Hey Admin! ENV['#{env_var_name}'] is not set."
    nil
  end
end
