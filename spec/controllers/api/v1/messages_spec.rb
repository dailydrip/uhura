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

    context 'when it does not have Xteam id in the header' do
      let(:header_without_team_id) do
        {
          'Authorization' => 'Bearer ' + ApiKey.first.auth_token,
          'Content-Type' => 'application/json'
        }
      end

      it 'returns an error saying the Team ID is not found' do
        stub_request(:any, /api.getclearstream.com/).to_return(body: get_clearstream_response_data('post_message'),
                                                               status: 200,
                                                               headers: { 'Content-Length' => 3 })
        post '/api/v1/messages', headers: header_without_team_id, params: valid_attributes.to_json
        expect(response.status).to eq 422
        expect(response.parsed_body['error']).to eq('Team name (X-Team-ID HTTP header)  NOT found!')
      end
    end

    context 'when it is authorized' do
      it 'returns status code 200' do
        stub_request(:any, /api.getclearstream.com/).to_return(body: get_clearstream_response_data('post_message'),
                                                               status: 200,
                                                               headers: { 'Content-Length' => 3 })
        post '/api/v1/messages', headers: valid_headers, params: valid_attributes.to_json
        expect(response.status).to eq 200
        expect(response.parsed_body['status']).to eq(202)
      end
    end

    describe 'when the prefered channel is email' do
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
      it 'calls sendgrid returning the data' do
          #FIXME: Make the stub_request to sendgrid and test it here
      end
    end

    describe 'when the prefered channel is sms' do
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
      it 'calls clearstream returning the data' do
          #FIXME: Make the stub_request to clearstream and test it here
      end
    end
  end
end
