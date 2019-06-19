Sidekiq.configure_server do |config|
  config.logger.level = ::Logger::DEBUG

  Rails.logger = Sidekiq::Logging.logger
  ActiveRecord::Base.logger = Sidekiq::Logging.logger
end