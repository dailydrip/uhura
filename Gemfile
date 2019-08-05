# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'administrate-field-nested_has_many', '~> 1.1.0'
gem 'administrate', github: 'thoughtbot/administrate'
gem 'chartkick', '~> 3.2.1'           # Charts in admin app
gem 'envied', '~> 0.9.3'              # Ensure presence and type of your app's ENV-variables
gem 'faraday', '~> 0.15.4'            # For Clearstream
gem 'faraday_middleware', '~> 0.13.1' # For Clearstream
gem 'font-awesome-sass', '~> 5.6', '>= 5.6.1'
gem 'groupdate', '~> 4.1.2'           # For grouping temporal data
gem 'highlands_auth', git: 'git@github.com:highlands/highlands_auth.git', branch: 'master'
gem 'jbuilder', '~> 2.5'              # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'json', '~> 2.2.0'                # For Clearstream
gem 'logdna', '~> 1.3.0'              # Logging
gem 'lograge', '~> 0.11.2'            # Logging
gem 'logstash-event', '~> 1.2.02'     # Logging
gem 'pg', '>= 0.18', '< 2.0'          # Use postgresql as the database for Active Record
gem 'puma', '~> 3.11'                 # Use Puma as the app server
gem 'rack-timeout', '~> 0.5.1'        # Configure Rails middleware with a default timeout of 15
gem 'rails', '~> 6.0.0.rc1'           # You can bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'sendgrid-ruby', '~> 6.0.0'       # For sending emails
gem 'sidekiq', '~>5.2.7'              # Simple, efficient background processing for Ruby
gem 'slim', '~> 4.0.1'                # Web server
gem 'systemu', '~> 2.6.5'             # Logging
gem 'turbolinks', '~> 5'              # Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'typhoeus', '~> 1.3.1'            # For Clearstream
gem 'webpacker', '~> 4.0'             # Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker

group :development, :test do
  gem 'awesome_print', '~> 1.8.0'
  gem 'byebug', '~> 11.0.1', platforms: %i[mri mingw x64_mingw]
  gem 'faker', '~> 2.1.0'
  gem 'hashdiff', ['>= 1.0.0.beta1', '< 2.0.0'] # https://github.com/liufengyun/hashdiff/issues/45#issuecomment-499566400
  gem 'hirb', '~> 0.7.3'
  gem 'rubocop-performance', '~> 1.4.1'
  gem 'rubocop-rails', '~> 2.2.1'
  gem 'webmock', '~> 3.6.0'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'database_cleaner', '~> 1.7.0'
  gem 'factory_bot_rails', '~> 5.0.2'
  gem 'rails-controller-testing', '~> 1.0.4'
  gem 'rspec-rails', '~> 3.8.2'
  gem 'selenium-webdriver', '~> 3.142.3'
  gem 'shoulda-matchers', '~> 4.1.2'
  gem 'webdrivers', '~> 4.1.2'
end
