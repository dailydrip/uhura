# frozen_string_literal: true

require 'sinatra/base'

class FakeExternalServer < Sinatra::Base

  private

  def sendgrid_json_response(response_code, file_name)
    read_json_response('sendgrid', response_code, file_name)
  end

  def json_response(response_code, file_name)
    read_json_response('clearstream', response_code, file_name)
  end

  def read_json_response(external_app_name, response_code, file_name)
    content_type :json
    status response_code

    fixture_path = "#{File.dirname(__FILE__)}/fixtures/#{external_app_name}/#{file_name}.json"
    if !File.exist?(fixture_path)
      puts "Fixture file (#{fixture_path}) not found!"
    else
      File.open(fixture_path).read
    end
  end
end
