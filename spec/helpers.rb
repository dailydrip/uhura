# frozen_string_literal: true

module Helpers
  def get_clearstream_request_data(file_name)
    File.open("#{FIXTURE_DIR}/clearstream/#{file_name}_request.json").read
  end
  def get_clearstream_response_data(file_name)
    File.open("#{FIXTURE_DIR}/clearstream/#{file_name}.json").read
  end
  def get_sendgrid_request_data(file_name)
    File.open("#{FIXTURE_DIR}/sendgrid/#{file_name}_request.json").read
  end
  def get_sendgrid_response_data(file_name)
    File.open("#{FIXTURE_DIR}/sendgrid/#{file_name}.json").read
  end
end
