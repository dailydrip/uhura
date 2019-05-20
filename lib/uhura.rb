# frozen_string_literal: true

require "#{__dir__}/uhura/config"
require "#{__dir__}/uhura/version"
require "#{__dir__}/uhura/status"
require "#{__dir__}/uhura/logging"

require_relative 'clearstream_client'

# Uhura Constants
class K
  SOURCE_ENUM = [
    SOURCE_SERVER_ID = ENV['SOURCE_SERVER_ID'].to_i || 1,
    LOG_INFO_ID = ENV['LOG_INFO_ID'].to_i || 1,
    LOG_ERROR_ID = ENV['LOG_ERROR_ID'].to_i || 2,
    LOG_WARNING_ID = ENV['LOG_WARNING_ID'].to_i || 3
  ].freeze
end
