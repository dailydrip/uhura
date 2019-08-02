# frozen_string_literal: true

module Helpers
  # Sendgrid
  def get_sendgrid_request_data(file_name)
    File.open("#{FIXTURE_DIR}/sendgrid/#{file_name}_request.json").read
  end

  def get_sendgrid_response_data(file_name)
    File.open("#{FIXTURE_DIR}/sendgrid/#{file_name}.json").read
  end

  # Clearstream
  def get_clearstream_request_data(file_name)
    File.open("#{FIXTURE_DIR}/clearstream/#{file_name}_request.json").read
  end

  def get_clearstream_response_data(file_name)
    File.open("#{FIXTURE_DIR}/clearstream/#{file_name}.json").read
  end

  # Highlands
  def get_highlands_request_data(file_name)
    File.open("#{FIXTURE_DIR}/highlands/#{file_name}_request.json").read
  end

  def get_highlands_response_data(file_name)
    File.open("#{FIXTURE_DIR}/highlands/#{file_name}.json").read
  end
end
