# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |c|
  c.include Helpers
end

RSpec.describe 'External list requests to Clearstream', type: :request do
  it 'get all lists' do
    uri = URI('https://api.getclearstream.com/v1/lists')
    # Send request to fake clearstream server (redirected to FackClearstream server)
    response = JSON.parse(Net::HTTP.get(uri))
    expect(response['all']['data'].first['id']).to eq 25_041
  end

  it 'get one list' do
    uri = URI('https://api.getclearstream.com/v1/lists/25041')
    # Send request to fake clearstream server (redirected to FackClearstream server)
    response = JSON.parse(Net::HTTP.get(uri))
    expect(response['list']['data']['id']).to eq 25_041
  end

  it 'create a list with taken name' do
    uri = URI('https://api.getclearstream.com/v1/lists')
    # Get request data from fixture
    form_data = JSON.parse(get_request_data('post_list__name_taken'))
    # Send request to fake clearstream server (redirected to FackClearstream server)
    response = Net::HTTP.post_form(uri, form_data)
    response = JSON.parse(response.body)['error']
    expect(response['http_code']).to eq 422
    expect(response['message']).to eq 'The name has already been taken.'
  end

  it 'create a list' do
    uri = URI('https://api.getclearstream.com/v1/lists')
    # Get request data from fixture
    form_data = JSON.parse(get_request_data('post_list'))
    # Send request to fake clearstream server (redirected to FackClearstream server)
    response = Net::HTTP.post_form(uri, form_data)
    response = JSON.parse(response.body)['data']
    expect(response['name']).to eq 'Brand New List'
    expect(response['subscriber_count']).to eq 0
  end

  it 'update a list' do
    uri = URI('https://api.getclearstream.com/v1/lists/25041')
    # Get request data from fixture
    form_data = JSON.parse(get_request_data('patch_list'))
    # Send request to fake clearstream server (redirected to FackClearstream server)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Patch.new(uri.request_uri)
    request.set_form_data(form_data)
    request['Content-Type'] = 'application/json'
    response = http.request(request)
    response = JSON.parse(response.body)['list']['data']
    expect(response['name']).to eq 'New List UPDATED'
    expect(response['subscriber_count']).to eq 1
  end

  it 'delete a list' do
    uri = URI('https://api.getclearstream.com/v1/lists/25056')
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Delete.new(uri.request_uri)
    request['Content-Type'] = 'application/json'
    # Send request to fake clearstream server (redirected to FackClearstream server)
    response = http.request(request)
    response = JSON.parse(response.body)['list']
    expect(response['id']).to eq 25_056
    expect(response['deleted']).to eq true
  end
end
