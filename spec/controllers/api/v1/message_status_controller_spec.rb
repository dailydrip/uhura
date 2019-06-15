# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'MessageStatus API', type: :request do
  before do
    setup_data
  end

  describe 'GET /api/v1/message_status' do
    let(:manager) do Manager.first; end
    let(:receiver) do Receiver.first; end

    context 'when it is authorized' do
      it 'returns status code 200' do
        get '/api/v1/message_status/1', headers: valid_headers, params: nil
        expect(response.status).to eq 200
        expect(response.parsed_body['data']['sent_to_sendgrid']).to_not be_nil
        expect(response.parsed_body['data']['mail_and_response']).to_not be_nil
        expect(response.parsed_body['data']['mail_and_response']['mail']).to_not be_nil
        expect(response.parsed_body['data']['mail_and_response']['response']).to_not be_nil
      end
    end
  end
end