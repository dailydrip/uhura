# frozen_string_literal: true

require 'faraday_middleware'

module ClearstreamClient
  class BaseClient
    APIError = Class.new(StandardError)
    CS_BASE_URL = ClearstreamClient::Config.base_url

    def initialize(options = {})
      @data = options[:data].to_h
      @api_key = ENV['CLEARSTREAM_KEY']
      @resource = options[:resource]
    end

    def index
      response = connection.get do |req|
        req.url "#{CS_BASE_URL}/#{@resource}"
      end

      JSONConverter.to_hash(response.body)
    end

    def create
      response = connection.post(@resource, @data)
      raise APIError, response.body unless response.success?

      JSONConverter.to_hash(response.body)
    end

    def show(id)
      # Build and send request
      response = connection.get do |req|
        req.url "#{CS_BASE_URL}/#{@resource}/#{id}"
      end
      raise APIError, response.body unless response.success?

      JSONConverter.to_hash(response.body)
    end

    def destroy(id)
      response = connection.delete do |req|
        req.url "#{CS_BASE_URL}/#{@resource}/#{id}"
      end
      raise APIError, response.body unless response.success?

      JSONConverter.to_hash(response.body)
    end

    def patch(id)
      response = connection.patch do |req|
        req.url "#{CS_BASE_URL}/#{@resource}/#{id}"
        req.body = @data.to_h # .except!(:id)
      end
      raise APIError, response.body unless response.success?

      JSONConverter.to_hash(response.body)
    end

    private

    # rubocop:disable Layout/AlignHash
    def headers
      {
        'X-Api-Key'    =>  @api_key.to_s,
        'Content-Type' => 'application/json'
      }
    end
    # rubocop:enable Layout/AlignHash

    def connection
      Faraday.new(url: ClearstreamClient::Config.base_url, headers: headers) do |builder|
        builder.request :json
        builder.adapter :typhoeus # typphous is much faster than net_http
      end
    end
  end
end
