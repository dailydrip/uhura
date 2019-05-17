source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.1'

gem 'rails', '~> 6.0.0.rc1'   # You can bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'pg', '>= 0.18', '< 2.0'  # Use postgresql as the database for Active Record
gem 'puma', '~> 3.11'         # Use Puma as the app server
gem 'sass-rails', '~> 5'      # Use SCSS for stylesheets
gem 'webpacker', '~> 4.0'     # Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'turbolinks', '~> 5'      # Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'jbuilder', '~> 2.5'      # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder

# gem 'redis', '~> 4.0'         # Use Redis adapter to run Action Cable in production
# gem 'bcrypt', '~> 3.1.7'      # Use Active Model has_secure_password
# gem 'image_processing', '~> 1.2' # Use Active Storage variant
# gem 'bootsnap', '>= 1.4.2', require: false  # Reduces boot times through caching; required in config/boot.rb

gem 'rack-timeout'            # Configure Rails middleware with a default timeout of 15
gem 'envied'                  # Ensure presence and type of your app's ENV-variables
gem 'sendgrid-ruby'           # For sending emails

# For Clearstream
gem 'faraday'
gem 'faraday_middleware'
gem 'json'
gem 'typhoeus'

gem 'highlands_auth', :git => 'git@github.com:highlands/highlands_auth.git', :branch => 'master'
gem "haml-rails" #, "~> 2.0"

# gem 'bootstrap', '~> 4.3', '>= 4.3.1'
gem 'font-awesome-sass', '~> 5.6', '>= 5.6.1'
#gem 'administrate', github: 'thoughtbot/administrate'
gem 'administrate', github: 'l3x/administrate'
# gem 'devise', '~> 4.6', '>= 4.6.1'
# gem 'devise-bootstrapped', github: 'l3x/devise-bootstrapped'
# gem 'friendly_id', '~> 5.2', '>= 5.2.5'
# gem 'gravatar_image_tag', github: 'mdeering/gravatar_image_tag'
# gem 'mini_magick', '~> 4.9', '>= 4.9.2'
# gem 'name_of_person', '~> 1.1'
# gem 'omniauth-facebook', '~> 5.0'
# gem 'omniauth-github', '~> 1.3'
# gem 'omniauth-twitter', '~> 1.4'


group :development, :test do
  gem 'faker'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec'
  gem 'webmock'
  gem 'awesome_print'
  gem 'rubocop', require: false
  gem 'rubocop-performance'
  gem 'hirb'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'webdrivers'    # Easy installation and use of web drivers to run system tests with browsers
  gem 'database_cleaner'
  gem 'factory_bot'
  gem 'factory_bot_rails'
  #gem 'launchy'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'rails-controller-testing'
end

