# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Messages API', type: :request do
  describe 'POST /api/v1/messages' do
    let(:valid_attributes) do
      receiver = Receiver.first
      manager = Manager.first

      body = {
        "public_token": manager.public_token,
        "receiver_sso_id": receiver.receiver_sso_id,
        "email_subject": 'Picnic Saturday',
        "email_message": {
          "header": 'Dragon Rage',
          "section1": 'imagine you are writing an email.',
          "button": 'Count me in!'
        },
        "template_id": 'd-f986df533e514f978f4460bedca50db0',
        "sms_message": 'Come in now for 50% off all rolls!'
      }
    end

    context 'when it is not authorized' do
      it 'returns 401 with an error in the body' do
        stub_request(:any, /api.getclearstream.com/).to_return(body: get_clearstream_response_data('invalid_auth_header'),
                                                               status: 200,
                                                               headers: { 'Content-Length' => 3 })

        post '/api/v1/messages', headers: invalid_headers, params: valid_attributes
        expect(response.status).to eq 401
        expect(response.parsed_body).to eq('error' => 'This Api Key does not exist.')
      end
    end

    context 'when it is  authorized' do
      it 'returns 401 with an error in the body' do
        stub_request(:any, /api.getclearstream.com/).to_return(body: get_clearstream_response_data('post_message'),
                                                               status: 200,
                                                               headers: { 'Content-Length' => 3 })

        post '/api/v1/messages', headers: valid_headers, params: valid_attributes.to_json

        expect(response.status).to eq 200
        expect(response.parsed_body['status']).to eq(202)
      end
    end

    context 'when it has right public token and authorization' do
    end

    context 'when it does not have Xteam id in the header' do
    end

    context 'when request is valid' do
      before do
        stub_request(:any, /api.getclearstream.com/).to_return(body: '<pu there whatever you think it will return>', status: 200, headers: { 'Content-Length' => 3 })
        stub_request(:any, /api.sendgrid.com/).to_return(body: '<put  here whatever you think it will return>', status: 200, headers: { 'Content-Length' => 3 })
      end

      let(:valid_headers) {}

      let(:valid_attributes)  {}

      it 'returns status code 200' do
        # Really call sendgrid and clearstream
        # expect(response).to have_http_statu(200)
      end

      it 'does return an error from clearstream' do
        # stub_request(:any, /api.getclearstream.com/).to_return(body: "<put there whatever you think it will return>", status: 500, headers: { 'Content-Length' => 3 })
        # stub_request(:any, /api.sendgrid.com/).to_return(body: "<put  here whatever you think it will return>", status: 200, headers: { 'Content-Length' => 3 })
        # post '/api/v1/messages', headers: valid_headers, params: valid_attributes
      end
    end
  end
end
