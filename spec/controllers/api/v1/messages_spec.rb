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

    context 'when it is authorized' do
      it 'returns status code 200' do
        stub_request(:any, /api.getclearstream.com/).to_return(body: get_clearstream_response_data('post_message'),
                                                               status: 200,
                                                               headers: { 'Content-Length' => 3 })
        post '/api/v1/messages', headers: valid_headers, params: valid_attributes.to_json
        expect(response.status).to eq 200
        expect(response.parsed_body['data']['clearstream_msg']['status']).to eq('QUEUED')
      end
    end

    context 'when it is not authorized' do
      it 'returns 401 with an error in the body' do
        stub_request(:any, /api.getclearstream.com/).to_return(body: get_clearstream_response_data('invalid_auth_header'),
                                                               status: 401,
                                                               headers: { 'Content-Length' => 3 })
        post '/api/v1/messages', headers: invalid_headers, params: valid_attributes
        expect(response.status).to eq 401
        expect(response.parsed_body['error']).to eq('This API Key does not exist.')
      end
    end

    context 'when it is missing the X-Team-ID HTTP header' do
      let(:header_without_team_id) do
        {
            'Authorization' => 'Bearer ' + ApiKey.first.auth_token,
            'Content-Type' => 'application/json'
        }
      end
      it 'returns an error saying the Team ID is not found' do
        stub_request(:any, /api.getclearstream.com/).to_return(body: get_clearstream_response_data('post_message'),
                                                               status: 422,
                                                               headers: { 'Content-Length' => 3 })
        post '/api/v1/messages', headers: header_without_team_id, params: valid_attributes.to_json
        expect(response.status).to eq 422
        expect(response.parsed_body['error']).to eq('Required HTTP header (X-Team-ID) is missing.')
      end
    end

    context 'when it has an invalid X-Team-ID HTTP header' do
      let(:header_without_team_id) do
        {
            'Authorization' => 'Bearer ' + ApiKey.first.auth_token,
            'Content-Type' => 'application/json',
            'X-Team-ID' => 'BOGUS_DATA'
        }
      end
      it 'returns an error saying the X-Team-ID HTTP header was NOT found' do
        stub_request(:any, /api.getclearstream.com/).to_return(body: get_clearstream_response_data('post_message'),
                                                               status: 422,
                                                               headers: { 'Content-Length' => 3 })
        post '/api/v1/messages', headers: header_without_team_id, params: valid_attributes.to_json
        expect(response.status).to eq 422
        expect(response.parsed_body['error']).to include('X-Team-ID HTTP header NOT found')
      end
    end

    describe 'when the preferred channel is sms' do
      let(:valid_attributes) do
        receiver = Receiver.find_by(first_name: 'Alice')
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
      it 'calls clearstream returning a status of QUEUED' do
        stub_request(:any, /api.getclearstream.com/).to_return(body: get_clearstream_response_data('post_message'),
                                                               status: 200,
                                                               headers: { 'Content-Length' => 3 })
        post '/api/v1/messages', headers: valid_headers, params: valid_attributes.to_json
        expect(response.status).to eq 200
        expect(response.parsed_body['data']['clearstream_msg']['status']).to eq('QUEUED')
      end
    end

    describe 'when the sms reciever has an invalid mobile_number' do
      let(:valid_attributes) do
        receiver = Receiver.first
        receiver.mobile_number = '?+!42'
        receiver.save!
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
      it 'Clearstream does not process it' do
        stub_request(:any, /api.getclearstream.com/).to_return(body: get_clearstream_response_data('post_message_with_invalid_receiver_mobile_number'),
                                                               status: 422,
                                                               headers: { 'Content-Length' => 3 })
        post '/api/v1/messages', headers: valid_headers, params: valid_attributes.to_json
        expect(response.status).to eq 422
        expect(response.parsed_body['error']['msg']).to eq('At least one of the supplied subscribers is invalid.')
      end
    end

    describe 'when the preferred channel is email' do
      let(:valid_attributes) do
        receiver = Receiver.find_by(first_name: 'Bob')
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
      it 'calls Sendgrid and returns a successful sendgrid_response' do
        stub_request(:any, /api.sendgrid.com/).to_return(body: get_sendgrid_response_data('post_message'),
                                                         status: 200,
                                                         headers: { 'Content-Length' => 3 })
        post '/api/v1/messages', headers: valid_headers, params: valid_attributes.to_json
        expect(response.status).to eq 200
        expect(response.parsed_body['data']['sendgrid_msg']['sendgrid_response']).to eq('200')
      end
    end

    describe 'when an email with an invalid template_id is sent' do
      let(:valid_attributes) do
        receiver = Receiver.find_by(first_name: 'Bob')
        manager = Manager.first
        body = {
            "public_token": manager.public_token,
            "receiver_sso_id": receiver.receiver_sso_id,
            "email_subject": 'Picnic Next Saturday',
            "email_message": {
                "header": 'Bind',
                "section1": "You're more like a game show host.",
                "section2": "I think we can get her a guest shot on 'Wild Kingdom.' I just whacked her up with about 300 cc's of Thorazaine... she's gonna take a little nap now.",
                "button": 'Action!'
            },
            "template_id": '4d10bf26b57247deba602127dab1ba60',
            "sms_message": 'Bring Dessert to the Picnic Next Saturday'
        }
      end
      it 'returns status code 422' do
        stub_request(:any, /api.sendgrid.com/).to_return(body: get_sendgrid_response_data('post_message'),
                                                         status: 422,
                                                         headers: { 'Content-Length' => 3 })
        post '/api/v1/messages', headers: valid_headers, params: valid_attributes.to_json
        expect(response.status).to eq 422
        expect(response.parsed_body['error']).to include('Validation failed: Template must exist')
      end
    end

    describe 'when and email with 1 section is sent' do
      let(:valid_attributes) do
        receiver = Receiver.find_by(first_name: 'Bob')
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
      it 'returns status code 200' do
        stub_request(:any, /api.sendgrid.com/).to_return(body: get_sendgrid_response_data('post_message'),
                                                         status: 200,
                                                         headers: { 'Content-Length' => 3 })
        post '/api/v1/messages', headers: valid_headers, params: valid_attributes.to_json
        expect(response.status).to eq 200
        expect(response.parsed_body['data']['sendgrid_msg']['mail_and_response']['mail']['personalizations'][0]['dynamic_template_data']['section1']).to eq('imagine you are writing an email.')
      end
    end

    describe 'when an email with 2 sections is sent' do
      let(:valid_attributes) do
        receiver = Receiver.find_by(first_name: 'Bob')
        manager = Manager.first
        body = {
            "public_token": manager.public_token,
            "receiver_sso_id": receiver.receiver_sso_id,
            "email_subject": "Picnic Next Saturday",
            "email_message": {
                "header": "Bind",
                "section1": "You're more like a game show host.",
                "section2": "I think we can get her a guest shot on 'Wild Kingdom.' I just whacked her up with about 300 cc's of Thorazaine... she's gonna take a little nap now.",
                "button": "Action!"
            },
            "template_id": "d-4d10bf26b57247deba602127dab1ba60",
            "sms_message": "Bring Dessert to the Picnic Next Saturday"
        }
      end
      it 'returns status code 200' do
        stub_request(:any, /api.sendgrid.com/).to_return(body: get_sendgrid_response_data('post_message'),
                                                         status: 200,
                                                         headers: { 'Content-Length' => 3 })
        post '/api/v1/messages', headers: valid_headers, params: valid_attributes.to_json
        expect(response.status).to eq 200
        expect(response.parsed_body['data']['sendgrid_msg']['mail_and_response']['mail']['personalizations'][0]['dynamic_template_data']['section2']).to eq("I think we can get her a guest shot on 'Wild Kingdom.' I just whacked her up with about 300 cc's of Thorazaine... she's gonna take a little nap now.")
      end
    end

    describe 'when an email with no sections sent' do
      let(:valid_attributes) do
        receiver = Receiver.find_by(first_name: 'Bob')
        manager = Manager.first
        body = {
            "public_token": manager.public_token,
            "receiver_sso_id": receiver.receiver_sso_id,
            "email_subject": "Picnic Saturday",
            "email_message": {
                "header": "Dragon Rage",
                "button": "Count me in!"
            },
            "template_id": "d-f986df533e514f978f4460bedca50db0",
            "sms_message": "Bring Drinks to the Picnic this Saturday"
        }
      end
      it 'returns status code 422' do
        stub_request(:any, /api.sendgrid.com/).to_return(body: get_sendgrid_response_data('post_message_0_sections'),
                                                         status: 422,
                                                         headers: { 'Content-Length' => 3 })
        expect do
          post('/api/v1/messages',
               headers: valid_headers,
               params: valid_attributes.to_json).to raise_error(MessageParamsVo::InvalidMessage, /invalid message_params_vo/)
        end
      end
    end
  end
end
