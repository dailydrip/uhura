# frozen_string_literal: true

# rubocop:disable Layout/AlignHash

require 'rails_helper'

RSpec.describe 'SendGrid API', type: :request do
  describe 'POST /api/v1/sg_emails' do
    let(:valid_attributes) do
      {
        'from_email': 'alice@gmail.com',
        'to_email':   'bob@gmail.com',
        'subject':    'A test from Rails',
        'content':    'How R U?'
      }.to_json
    end

    it 'get all messages' do
      uri = URI(ENV['API_ENDPOINT'] + 'sg_emails')
      response = JSON.parse(Net::HTTP.get(uri))
      expect(response['all'].first['id']).to eq 1
      expect(response['all'].first['response_status_code']).to eq '202'
    end

    it 'send a message' do
      uri = URI(ENV['API_ENDPOINT'] + 'sg_emails')
      # Get request data from fixture
      form_data = JSON.parse(get_sendgrid_request_data('post_sg_email'))

      # Post request to fake clearstream server
      #response = Net::HTTP.post_form(uri, form_data)
      request = Net::HTTP::Post.new(uri.request_uri)
      request.set_form_data(form_data)
      request["User-Agent"] = "Ruby Spec"
      request["Accept"] = "*/*"
      request["Content-Type"] = "application/json"
      request['Authorization'] = 'Basic ' + ENV['ADMIN_BASE64_CREDS']
      http = Net::HTTP.new(uri.host, uri.port)
      response = http.request(request)

      response = JSON.parse(response.body)
      expect(response['status']).to eq '202'
    end



    # context 'when request is valid' do
    #   before { post '/api/v1/sg_emails', headers: valid_headers, params: valid_attributes }
    #
    #   it 'sends sg_email' do
    #     expect(json['response_status_code']).to eq(nil)
    #   end
    #
    #   it 'returns status code 202' do
    #     expect(response).to have_http_status(202)
    #   end
    # end

    # context 'when the request header is missing basic auth info' do
    #   before { post '/api/v1/sg_emails', headers: invalid_headers, params: valid_attributes }
    #
    #   it 'returns status code 401' do
    #     expect(response).to have_http_status(401)
    #   end
    # end
    #
    # context 'when the request auth header is good, but the body is invalid' do
    #   let(:invalid_attributes) { { from_email: nil }.to_json }
    #   before { post '/api/v1/sg_emails', headers: valid_headers, params: invalid_attributes }
    #
    #   it 'returns status code 422' do
    #     expect(response.status).to eq 422
    #   end
    #
    #   it 'returns a validation failure message' do
    #     expect(json['error'])
    #       .to match('from_email' => ["can't be blank", 'is invalid'],
    #                 'to_email'   => ["can't be blank", 'is invalid', 'should be different than from_email'],
    #                 'subject'    => ["can't be blank"],
    #                 'content'    => ["can't be blank"])
    #   end
    # end
  end
end

# rubocop:enable Layout/AlignHash
