# frozen_string_literal: true

require 'faraday_middleware'

module HighlandsClient
  class BaseResource
    include ConversionHelper
    include ActiveModel::Validations
  end
end
