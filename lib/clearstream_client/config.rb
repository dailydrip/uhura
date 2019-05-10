# frozen_string_literal: true

module ClearstreamClient
  class Config
    def self.base_url
      ENV['CLEARSTREAM_BASE_URL'] || 'https://api.getclearstream.com/v1'
    end
  end
end
