require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
ENVied.require(*ENV['ENVIED_GROUPS'] || Rails.groups)

module Uhura
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Expose our application's helpers to Administrate
    config.to_prepare do
      Administrate::ApplicationController.helper Uhura::Application.helpers
    end

    # https://github.com/mperham/sidekiq/wiki/Active-Job
    config.active_job.queue_adapter = :sidekiq

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Suppress warnings when running rspec
    ActiveSupport::Deprecation.silenced = true

    # Load lib/uhura.rb
    config.autoloader = :classic

    config.application_name = Rails.application.class.parent_name

    # Set RSpec as default test framework
    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
