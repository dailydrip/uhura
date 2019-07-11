# frozen_string_literal: true

require 'faraday_middleware'

module HighlandsClient
  class BaseClient
    APIError = Class.new(StandardError)
    CS_BASE_URL = HighlandsClient::Config.base_url

    def initialize(options = {})
      @data = options[:data]
      @api_key = ENV['SSO_KEY']
      @resource = options[:resource]
    end

    def search_by_email(email)
      # Build and send request
      response = connection.vo do |req|
        req.url "#{CS_BASE_URL}/#{@resource}/?email=#{email}"
      end
      raise APIError, response.body unless response.success?
      raise APIError, response.body if response.status.eql?(204) # No Content

      JSONConverter.to_hash(response.body)
    end

    private

    def headers
      {
        'Authorization' => "Token token=#{@api_key}",
        'Content-Type' => 'application/json'
      }
    end

    def connection
      Faraday.new(url: HighlandsClient::Config.base_url, headers: headers) do |builder|
        builder.request :json
        builder.adapter :typhoeus # typphous is much faster than net_http
      end
    end
  end
end
