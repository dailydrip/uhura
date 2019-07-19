# Load uhura's config, utils and version files
require "#{Rails.root}/lib/uhura"

# Load SendGrid
require 'sendgrid-ruby'
include SendGrid

if ENV['UHURA_LOGGER'].eql?('LOGDNA')
  APP_LOGGER =  Logdna::Ruby.new(ENV['LOGDNA_KEY'], {
      :hostname => Host.name,
      :ip =>  IP.addr,
      :mac => Mac.addr,
      :app => Rails.application.class.parent.to_s.underscore,
      :level => ENV['LOG_LEVEL'] || 'INFO',
      :env => Rails.env,
      #:meta => {:once => {:first => "nested1", :another => "nested2"}},
      :endpoint => ENV['LOG_ENDPOINT'] ||  'https://logs.logdna.com/logs/ingest'
  })
else
  APP_LOGGER = Rails.logger
end
