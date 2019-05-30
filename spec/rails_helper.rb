# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'
require 'database_cleaner'
require 'slim'
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
Dir[Rails.root.join('spec/api/**/*.rb')].each { |f| require f }
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.include FactoryBot::Syntax::Methods
  # config.include Devise::Test::ControllerHelpers, type: :controller
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end
  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end
  config.before(:each) do
    DatabaseCleaner.start
  end
  config.after(:each) do
    DatabaseCleaner.clean
  end
  config.before(:all) do
    DatabaseCleaner.start
  end
  config.after(:all) do
    DatabaseCleaner.clean
  end
  config.infer_spec_type_from_file_location!

  # # Filter lines from Rails gems in backtraces.
  # config.filter_rails_from_backtrace!
  # # arbitrary gems may also be filtered via:
  # # config.filter_gems_from_backtrace("gem name")
  # #

  # Include spec/support helpers
  config.include RequestSpecHelper
  config.include ControllerSpecHelper
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
