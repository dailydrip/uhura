# frozen_string_literal: true

require 'faraday_middleware'

module ClearstreamClient
  class BaseResource
    include ConversionHelper
    include ActiveModel::Validations
  end
end
