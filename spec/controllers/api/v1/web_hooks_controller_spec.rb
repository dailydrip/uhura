# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Web Hooks', type: :request do
  let(:sengrid_data) do
    [
      {
        "email": 'example@test.com',
        "timestamp": 1_560_968_476,
        "smtp-id": '<14c5d75ce93.dfd.64b469@ismtpd-555>',
        "event": 'processed',
        "category": 'cat facts',
        "sg_event_id": 'EHJ1GUQ1D9p_bwv0X2gHpA==',
        "sg_message_id": '14c5d75ce93.dfd.64b469.filter0001.16648.5515E0B88.0'
      },
      {
        "email": 'example@test.com',
        "timestamp": 1_560_968_476,
        "smtp-id": '<14c5d75ce93.dfd.64b469@ismtpd-555>',
        "event": 'deferred',
        "category": 'cat facts',
        "sg_event_id": 'EtAZAnp_pOLoRDSOBz5O1w==',
        "sg_message_id": '14c5d75ce93.dfd.64b469.filter0001.16648.5515E0B88.0',
        "response": '400 try again later',
        "attempt": '5'
      }
    ]
  end

  describe 'POST /api/v1/web_hooks/sendgrid' do
    it 'returns status code 200' do
      create(:sendgrid_msg, x_message_id: '14c5d75ce93.dfd.64b469.filter0001.16648.5515E0B88.0')
      post '/api/v1/web_hooks/sendgrid', params: sengrid_data.to_json, headers: { "Content-Type": 'application/json' }

      expect(response.status).to eq 204
      expect(SendgridMsg.first.status).to eq 'deferred'
    end
  end
end
