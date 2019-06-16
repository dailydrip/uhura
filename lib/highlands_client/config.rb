# frozen_string_literal: true

module HighlandsClient
  class Config
    def self.base_url
      ENV['HIGHLANDS_BASE_URL'] || 'https://sso.highlandsapp.com/api/v1'
    end
  end
end
