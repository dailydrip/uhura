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
      response = connection.get do |req|
        req.url "#{CS_BASE_URL}/#{@resource}/?email=#{email}"
      end
      render_error_msg(response.body) unless response.status.eql?(200)

      JSONConverter.to_hash(response.body)
    end

    def user_preferences(sso_id)
      # Build and send request
      response = connection.get do |req|
        req.url "#{CS_BASE_URL}/#{@resource}?id=#{sso_id}&token=#{ENV['SSO_TOKEN']}"
      end
      return error_msg(response.body) unless response.status.eql?(200)

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


    def error_msg(msg, status = unprocessable_entity)
      error_hash(message: msg)
    end

    def error_hash(msg, status = 422)
      status = Rack::Utils::SYMBOL_TO_STATUS_CODE[status] if status.is_a? Symbol
      {
          status: status,
          data: nil,
          error: msg
      }
    end

  end
end
