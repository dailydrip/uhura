# frozen_string_literal: true

module Config
  class << self
    def api_endpoint
      ENV['API_ENDPOINT'] || 'http://localhost:3000/api/v1/'
    end
  end
end
