# frozen_string_literal: true

class Api::V1::ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  rescue_from Exception, with: :show_errors
  before_action :set_default_format, :set_api_key

  private

  def set_default_format
    request.format = :json
  end

  def show_errors(exception)
    error_json = return_error(exception.to_s)
    render json: error_json, status: error_json[:status]
  end

  def set_api_key
    @api_key = ENV['CLEARSTREAM_KEY']
  end
end
