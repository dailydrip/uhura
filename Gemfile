# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'jbuilder', '~> 2.5'      # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'pg', '>= 0.18', '< 2.0'  # Use postgresql as the database for Active Record
gem 'puma', '~> 3.11'         # Use Puma as the app server
gem 'rails', '~> 6.0.0.rc1'   # You can bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'sidekiq', '~>5.2.7'      # Simple, efficient background processing for Ruby
gem 'turbolinks', '~> 5'      # Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'webpacker', '~> 4.0'     # Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker

gem 'chartkick'
gem 'envied'                  # Ensure presence and type of your app's ENV-variables
gem 'groupdate'
gem 'rack-timeout'            # Configure Rails middleware with a default timeout of 15
gem 'sendgrid-ruby'           # For sending emails

# For Clearstream
gem 'faraday'
gem 'faraday_middleware'
gem 'json'
gem 'typhoeus'

gem 'haml-rails' # , "~> 2.0"
gem 'highlands_auth', git: 'git@github.com:highlands/highlands_auth.git', branch: 'master'

gem 'administrate', github: 'thoughtbot/administrate'
gem 'administrate-field-nested_has_many'
gem 'font-awesome-sass', '~> 5.6', '>= 5.6.1'
gem 'logdna'
gem 'lograge'
gem 'logstash-event'
gem 'slim'
gem 'systemu'

group :development, :test do
  gem 'faker'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'rspec'
  gem 'webmock', '~>3.6.0'
  # https://github.com/liufengyun/hashdiff/issues/45#issuecomment-499566400
  gem 'awesome_print'
  gem 'hashdiff', ['>= 1.0.0.beta1', '< 2.0.0']
  gem 'hirb'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'database_cleaner'
  gem 'factory_bot'
  gem 'factory_bot_rails'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
  gem 'webdrivers' # Easy installation and use of web drivers to run system tests with browsers
end
