# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Request Test', type: :request do
  let(:headers) { valid_headers }

  describe 'POST /api/v1/sg_emails' do
    let(:valid_attributes) do
      {
        'from_email': 'alice@gmail.com',
        'to_email': 'bob@gmail.com',
        'subject': 'A test from Rails',
        'content': 'How R U?'
      }.to_json
    end

    context 'when request is valid' do
      before { post '/api/v1/sg_emails', params: valid_attributes, headers: headers }

      it 'sends sg_email' do
        expect(json['response_status_code']).to eq(nil)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      let(:invalid_attributes) { { from_email: nil }.to_json }
      before { post '/api/v1/sg_emails', params: invalid_attributes, headers: headers }

      # Note this should have status code of 422 when tested with an invalid authorization header
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns a validation failure message' do
        expect(json['message'])
          .to match('from_email' => ["can't be blank", 'is invalid'],
                    'to_email' => ["can't be blank", 'is invalid', 'should be different than from_email'],
                    'subject' => ["can't be blank"],
                    'content' => ["can't be blank"])
      end
    end
  end
end
