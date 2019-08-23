# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Messages API', type: :request do
  before do
    setup_data
  end

  describe 'GET /api/v1/messages/:id/status' do
    context 'when it is authorized' do
      let!(:message) do
        create(:message,
               clearstream_msg: create(:clearstream_msg, status: nil),
               sendgrid_msg: create(:sendgrid_msg, status: 'delivered'))
      end

      it 'returns status code 200' do
        get "/api/v1/messages/#{message.id}/status", headers: valid_headers
        expect(response.status).to eq 200
        expect(response.parsed_body).to eq('clearstream_msg_status' => nil, 'sendgrid_msg_status' => 'delivered')
      end
    end
  end

  describe 'POST /api/v1/messages' do
    let(:manager) { Manager.first; }
    let(:receiver) { Receiver.find_by(first_name: 'Alice'); }

    let(:valid_attributes) do
      {
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
        stub_request(:any, /api.getclearstream.com/)
          .to_return(body: get_clearstream_response_data('invalid_auth_header'),
                     status: 401)
        post '/api/v1/messages', headers: invalid_headers, params: valid_attributes
        expect(response.status).to eq 401
        expect(response.parsed_body['error']).to eq('This API Key does not exist.')
      end
    end

    context 'when it is authorized' do
      it 'returns status code 200' do
        stub_request(:any, /api.getclearstream.com/)
          .to_return(body: get_clearstream_response_data('post_message'),
                     status: 200)

        stub_request(:any, /sso.highlandsapp.com/)
          .to_return(body: get_highlands_response_data('alice_user_preferences'),
                     status: 200)

        post '/api/v1/messages', headers: valid_headers, params: valid_attributes.to_json
        expect(response.status).to eq 200
      end
    end

    context 'when receiver prefers sms messages' do
      it 'indicates that an SMS message was sent' do
        stub_request(:any, /api.getclearstream.com/)
          .to_return(body: get_clearstream_response_data('post_message'),
                     status: 200)

        stub_request(:any, /sso.highlandsapp.com/)
          .to_return(body: get_highlands_response_data('alice_user_preferences'),
                     status: 200)

        post '/api/v1/messages', headers: valid_headers, params: valid_attributes.to_json
        expect(response.parsed_body['clearstream_msg']['value']['data']['clearstream_msg']).to include('Asynchronously sent SMS')
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
        stub_request(:any, /api.getclearstream.com/)
          .to_return(body: get_clearstream_response_data('post_message'),
                     status: 422)
        post '/api/v1/messages', headers: header_without_team_id, params: valid_attributes.to_json
        expect(response.status).to eq 422
        expect(response.parsed_body['error']['message']).to eq('Required HTTP header (X-Team-ID) is missing.')
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
        stub_request(:any, /api.getclearstream.com/)
          .to_return(body: get_clearstream_response_data('post_message'),
                     status: 422)
        post '/api/v1/messages', headers: header_without_team_id, params: valid_attributes.to_json
        expect(response.status).to eq 422
        expect(response.parsed_body['error']['message']).to include('X-Team-ID HTTP header NOT found')
      end
    end

    describe 'when the preferred channel is sms' do
      it 'calls clearstream returning a status of QUEUED' do
        stub_request(:any, /api.getclearstream.com/)
          .to_return(body: get_clearstream_response_data('get_message_status_queued'),
                     status: 200)

        stub_request(:any, /sso.highlandsapp.com/)
          .to_return(body: get_highlands_response_data('alice_user_preferences'),
                     status: 200)

        get '/api/v1/message_status/2', headers: valid_headers, params: nil
        expect(response.status).to eq 200
        expect(response.parsed_body['message_status']['clearstream']).to eq('QUEUED')
      end
    end

    describe 'when the sms receiver has an invalid mobile_number' do
      def link_to_clearstream_invalid_mobile_number
        clearstream_msg = ClearstreamMsg.create!(
          sent_to_clearstream: 2.minutes.from_now,
          response: get_clearstream_response_data('read_invalid_subscriber'),
          got_response_at: 2.seconds.from_now,
          status: 'ERROR'
        )
        msg3 = Message.find(3)
        msg3.clearstream_msg = clearstream_msg
        msg3.save!
      end

      let(:valid_attributes) do
        receiver = Receiver.find_by(first_name: 'Alice')
        receiver.mobile_number = '?+!42'
        receiver.save!
        manager = Manager.first
        {
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
        stub_request(:any, /api.getclearstream.com/)
          .to_return(body: get_clearstream_response_data('post_message_with_invalid_receiver_mobile_number'),
                     status: 422)

        stub_request(:any, /sso.highlandsapp.com/)
          .to_return(body: get_highlands_response_data('alice_user_preferences'),
                     status: 200)

        post '/api/v1/messages', headers: valid_headers, params: valid_attributes.to_json
        # Just created 3rd message.
        link_to_clearstream_invalid_mobile_number
        expect(Message.last.clearstream_msg[:sent_to_clearstream]).to_not be_nil
        expect(JSON.parse(Message.last.clearstream_msg['response'])['error']['message']).to eq('At least one of the supplied subscribers is invalid.')
        expect(Message.last.status[:clearstream]).to eq('ERROR')
        # Verify message_status data:
        get "/api/v1/message_status/#{Message.find(3).id}", headers: valid_headers, params: nil
        expect(response.status).to eq 200
        expect(response.parsed_body['message_status']['sendgrid']).to be_nil
        expect(response.parsed_body['message_status']['clearstream']).to eq('ERROR')
      end
    end

    describe 'when the preferred channel is email' do
      def link_to_sendgrid
        sendgrid_msg = SendgridMsg.create!(sent_to_sendgrid: 2.seconds.from_now,
                                           mail_and_response: JSON.parse(get_sendgrid_response_data('read_mail_and_response')),
                                           got_response_at: nil,
                                           sendgrid_response: nil,
                                           read_by_user_at: nil)
        msg3 = Message.find(3)
        msg3.sendgrid_msg = sendgrid_msg
        msg3.save!
      end

      let(:receiver) { Receiver.find_by(first_name: 'Bob'); }
      let(:valid_attributes) do
        {
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
      it 'calls Sendgrid and returns a successful response and stores the message send request' do
        stub_request(:any, /api.sendgrid.com/)
          .to_return(body: get_sendgrid_response_data('post_message'),
                     status: 200)

        stub_request(:any, /sso.highlandsapp.com/)
          .to_return(body: get_highlands_response_data('bob_user_preferences'),
                     status: 200)

        post '/api/v1/messages', headers: valid_headers, params: valid_attributes.to_json
        # Just created 3rd message.
        expect(response.parsed_body['sendgrid_msg']['value']['status']).to eq(202)
        link_to_sendgrid
        expect(Message.last.sendgrid_msg.sent_to_sendgrid).to_not be_nil
        # Created new MesssageStatus
        get "/api/v1/message_status/#{Message.find(3).id}", headers: valid_headers, params: nil
        expect(response.status).to eq(200)
        expect(response.parsed_body['message_status']['sendgrid']).to eq('202')
      end
    end

    describe 'when an email with an invalid template_id is sent' do
      let(:receiver) { Receiver.find_by(first_name: 'Bob'); }
      let(:valid_attributes) do
        {
          "public_token": manager.public_token,
          "receiver_sso_id": receiver.receiver_sso_id,
          "email_subject": 'Picnic Next Saturday',
          "email_message": {
            "header": 'Bind',
            "section1": "You're more like a game show host.",
            "section2": "I think we can get her a guest shot on 'Wild Kingdom.' I just whacked her up with about 300 cc's of Thorazaine... she's gonna take a little nap now.",
            "button": 'Action!'
          },
          "template_id": '4d10bf26b57247deba602127dab1ba60-XXX',
          "sms_message": 'Bring Dessert to the Picnic Next Saturday'
        }
      end
      it 'returns status code 422' do
        stub_request(:any, /api.sendgrid.com/)
          .to_return(body: get_sendgrid_response_data('post_message_with_invalid_template_id'),
                     status: 422)

        stub_request(:any, /sso.highlandsapp.com/)
          .to_return(body: get_highlands_response_data('bob_user_preferences'),
                     status: 200)

        post '/api/v1/messages', headers: valid_headers, params: valid_attributes.to_json
        expect(response.status).to eq 422
        expect(response.parsed_body['error']['message']).to include('Invalid message')
      end
    end

    describe 'when and email with 1 section is sent' do
      let(:receiver) { Receiver.find_by(first_name: 'Bob'); }
      let(:valid_attributes) do
        {
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
        stub_request(:any, /api.sendgrid.com/)
          .to_return(body: get_sendgrid_response_data('post_message'),
                     status: 200)

        stub_request(:any, /sso.highlandsapp.com/)
          .to_return(body: get_highlands_response_data('bob_user_preferences'),
                     status: 200)

        post '/api/v1/messages', headers: valid_headers, params: valid_attributes.to_json
        expect(response.status).to eq 200
        expect(response.parsed_body['sendgrid_msg']['value']['data']['sendgrid_msg']).to include('Asynchronously sent email')
      end
    end

    describe 'when an email with 2 sections is sent' do
      let(:receiver) { Receiver.find_by(first_name: 'Bob'); }
      let(:valid_attributes) do
        {
          "public_token": manager.public_token,
          "receiver_sso_id": receiver.receiver_sso_id,
          "email_subject": 'Picnic Next Saturday',
          "email_message": {
            "header": 'Bind',
            "section1": "You're more like a game show host.",
            "section2": "I think we can get her a guest shot on 'Wild Kingdom.' I just whacked her up with about 300 cc's of Thorazaine... she's gonna take a little nap now.",
            "button": 'Action!'
          },
          "template_id": 'd-4d10bf26b57247deba602127dab1ba60',
          "sms_message": 'Bring Dessert to the Picnic Next Saturday'
        }
      end
      it 'returns status code 200' do
        stub_request(:any, /api.sendgrid.com/)
          .to_return(body: get_sendgrid_response_data('post_message'),
                     status: 200)

        stub_request(:any, /sso.highlandsapp.com/)
          .to_return(body: get_highlands_response_data('bob_user_preferences'),
                     status: 200)

        post '/api/v1/messages', headers: valid_headers, params: valid_attributes.to_json
        expect(response.status).to eq 200
        expect(response.parsed_body['sendgrid_msg']['value']['data']['sendgrid_msg']).to include('Asynchronously sent email')
      end
    end

    describe 'when an email with options is sent' do
      let(:receiver) { Receiver.find_by(first_name: 'Bob'); }
      let(:valid_attributes) do
        {
          "public_token": manager.public_token,
          "receiver_sso_id": receiver.receiver_sso_id,
          "email_subject": 'Picnic Next Saturday',
          "email_message": {
            "header": 'Bind',
            "section1": "You're more like a game show host.",
            "section2": "I think we can get her a guest shot on 'Wild Kingdom.' I just whacked her up with about 300 cc's of Thorazaine... she's gonna take a little nap now.",
            "button": 'Action!'
          },
          "email_options": {
            "cc": ['Alice Recipient <recipient1@example.com>', 'recipient2@example.com'],
            "bcc": ['recipient3@example.com', 'Bob Recipient  <recipient4@example.com>'],
            "reply_to": 'Cindy Recipient <recipient5@example.com>',
            "send_at": 1_577_854_800,
            "batch_id": 'YOUR_BATCH_ID'
          },
          "template_id": 'd-4d10bf26b57247deba602127dab1ba60',
          "sms_message": 'Bring Dessert to the Picnic Next Saturday'
        }
      end
      it 'returns status code 200' do
        stub_request(:any, /api.sendgrid.com/)
          .to_return(body: get_sendgrid_response_data('post_message'),
                     status: 200)

        stub_request(:any, /sso.highlandsapp.com/)
          .to_return(body: get_highlands_response_data('bob_user_preferences'),
                     status: 200)

        post '/api/v1/messages', headers: valid_headers, params: valid_attributes.to_json
        expect(response.status).to eq 200
        expect(response.parsed_body['sendgrid_msg']['value']['data']['sendgrid_msg']).to include('Asynchronously sent email')
      end
    end

    describe 'when an email with no sections sent' do
      let(:receiver) { Receiver.find_by(first_name: 'Bob'); }
      let(:valid_attributes) do
        {
          "public_token": manager.public_token,
          "receiver_sso_id": receiver.receiver_sso_id,
          "email_subject": 'Picnic Saturday',
          "email_message": {
            "header": 'Dragon Rage',
            "button": 'Count me in!'
          },
          "template_id": 'd-f986df533e514f978f4460bedca50db0',
          "sms_message": 'Bring Drinks to the Picnic this Saturday'
        }
      end
      it 'returns status code 422' do
        stub_request(:any, /api.sendgrid.com/)
          .to_return(body: get_sendgrid_response_data('post_message_0_sections'),
                     status: 422)

        stub_request(:any, /sso.highlandsapp.com/)
          .to_return(body: get_highlands_response_data('bob_user_preferences'),
                     status: 200)
        expect do
          post('/api/v1/messages',
               headers: valid_headers,
               params: valid_attributes.to_json).to raise_error(MessageParamsVo::InvalidMessageError, /invalid message_params_vo/)
        end
      end
    end
  end

  describe 'when an email with an invalid template_id is sent' do
    let(:receiver) { Receiver.find_by(first_name: 'Bob'); }
    let(:valid_attributes) do
      {
        "public_token": manager.public_token,
        "receiver_sso_id": receiver.receiver_sso_id,
        "email_subject": 'Picnic Saturday',
        "email_message": {
          "header": 'Dragon Rage',
          "button": 'Count me in!'
        },
        "template_id": 'XXX-f986df533e514f978f4460bedca50db0',
        "sms_message": 'Bring Drinks to the Picnic this Saturday'
      }
    end

    it 'returns status code 422' do
      stub_request(:any, /api.sendgrid.com/)
        .to_return(body: get_sendgrid_response_data('invalid_template_id'),
                   status: 422)

      stub_request(:any, /sso.highlandsapp.com/)
        .to_return(body: get_highlands_response_data('bob_user_preferences'),
                   status: 200)
      expect do
        post('/api/v1/messages',
             headers: valid_headers,
             params: valid_attributes.to_json).to raise_error(MessageParamsVo::InvalidMessageError, /invalid message_params_vo/)
      end
    end
  end
end
