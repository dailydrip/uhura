# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'MessageStatus API', type: :request do
  before do
    setup_data
  end

  describe 'GET /api/v1/message_status' do
    let(:manager) { Manager.first }
    let(:receiver) { Receiver.first }

    context 'when it is NOT authorized' do
      it 'returns status code 200' do
        get '/api/v1/message_status/1', headers: {}, params: nil
        expect(response.status).to eq(401)
        expect(response.parsed_body).to eq('status' => 422,
                                           'data' => nil,
                                           'error' => 'This API Key does not exist.')
      end
    end

    context 'when it is authorized' do
      it 'returns status code 200' do
        get '/api/v1/message_status/1', headers: valid_headers, params: nil
        expect(response.status).to eq(200)
      end
    end

    context 'when it is authorized and receiver prefers email but not sms' do
      it 'returns accepted_by_sendgrid and nil for clearstream' do
        get '/api/v1/message_status/1', headers: valid_headers, params: nil
        expect(response.parsed_body['message_status']['sendgrid']).to eq('accepted_by_sendgrid')
        expect(response.parsed_body['message_status']['clearstream']).to eq(nil)
      end
    end

    context 'when it is authorized and receiver prefers sms but not email' do
      it 'returns accepted_by_sendgrid and nil for clearstream' do
        get '/api/v1/message_status/2', headers: valid_headers, params: nil
        expect(response.parsed_body['message_status']['sendgrid']).to eq(nil)
        expect(response.parsed_body['message_status']['clearstream']).to eq('QUEUED')
      end
    end

  end
end
