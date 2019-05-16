# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |c|
  c.include Helpers
end

RSpec.describe 'External message requests to Clearstream', type: :request do
  it 'get all messages' do
    uri = URI('https://api.getclearstream.com/v1/messages')
    response = JSON.parse(Net::HTTP.get(uri))
    expect(response['all']['data'].first['status']).to eq 'SENT'
  end

  it 'get one message' do
    uri = URI('https://api.getclearstream.com/v1/messages/108047')
    response = JSON.parse(Net::HTTP.get(uri))
    expect(response['message']['data']['status']).to eq 'SENT'
  end

  it 'send a message' do
    uri = URI('https://api.getclearstream.com/v1/messages')
    # Get request data from fixture
    form_data = JSON.parse(get_request_data('post_message'))
    # Post request to fake clearstream server
    response = Net::HTTP.post_form(uri, form_data['message'])
    response = JSON.parse(response.body)['data']
    expect(response['status']).to eq 'QUEUED'
  end

  it 'delete one message' do
    uri = URI('https://api.getclearstream.com/v1/messages/108047')
    request = Net::HTTP::Delete.new(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    # Perform delete request
    response = http.request(request)
    response = JSON.parse(response.body)['error']
    expect(response['http_code']).to eq 403
    expect(response['message']).to eq 'Only unsent messages can be deleted.'
  end
end
