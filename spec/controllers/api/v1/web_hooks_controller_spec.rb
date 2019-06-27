# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Web Hooks', type: :request do
  context 'when SENDGRID' do
    let(:sengrid_data) do
      [
        {
          "email": 'example@test.com',
          "timestamp": 1_560_968_476,
          "smtp-id": '<14c5d75ce93.dfd.64b469@ismtpd-555>',
          "event": 'processed',
          "category": 'cat facts',
          "sg_event_id": 'EHJ1GUQ1D9p_bwv0X2gHpA==',
          "sg_message_id": '14c5d75ce93.dfd.64b469.filter0001.16648.5515E0B88.0',
          "uhura_msg_id": '681dc44a-5302-4cce-aa3b-932b21a79ab6'
        },
        {
          "email": 'example@test.com',
          "timestamp": 1_560_968_476,
          "smtp-id": '<14c5d75ce93.dfd.64b469@ismtpd-555>',
          "event": 'deferred',
          "category": 'cat facts',
          "sg_event_id": 'EtAZAnp_pOLoRDSOBz5O1w==',
          "sg_message_id": '14c5d75ce93.dfd.64b469.filter0001.16648.5515E0B88.0',
          "uhura_msg_id": '681dc44a-5302-4cce-aa3b-932b21a79ab6',
          "response": '400 try again later',
          "attempt": '5'
        }
      ]
    end

    describe 'POST /api/v1/web_hooks/sendgrid' do
      it 'returns status code 200' do
        create(:sendgrid_msg, id: '681dc44a-5302-4cce-aa3b-932b21a79ab6')
        post '/api/v1/web_hooks/sendgrid', params: sengrid_data.to_json, headers: { "Content-Type": 'application/json' }

        expect(response.status).to eq 204
        expect(SendgridMsg.first.status).to eq 'deferred'
      end
    end
  end

  context 'when CLEARSTREAM' do
    let(:clearstream_data) do
      {
        "created_at": '2019-01-01T10:02:00Z',
        "event": 'message.report',
        "data": {
          "message": {
            "id": 1_249_380,
            "status": 'SENT',
            "sent_at": '2019-01-01T09:30:00Z',
            "completed_at": '2019-01-01T09:32:00Z',
            "text": {
              "full": 'Blue Sushi: We have a really great weekend coming up! Stay tuned!',
              "header": 'Blue Sushi',
              "body": 'We have a really great weekend coming up! Stay tuned!'
            },
            "lists": [
              {
                "id": 193_029,
                "name": 'Master List'
              }
            ],
            "subscribers": [],
            "stats": {
              "recipients": 5300,
              "failures": 15,
              "replies": 22,
              "opt_outs": 19
            }
          }
        }
      }
    end

    describe 'POST /api/v1/web_hooks/sendgrid' do
      it 'returns status code 200' do
        create(:clearstream_msg, id: '1249380')
        post '/api/v1/web_hooks/clearstream', params: clearstream_data.to_json, headers: { "Content-Type": 'application/json' }

        expect(response.status).to eq 204
        expect(ClearstreamMsg.first.status).to eq 'SENT'
      end
    end
  end
end
