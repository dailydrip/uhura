# frozen_string_literal: true

# rubocop:disable Layout/AlignHash

require 'rails_helper'

RSpec.describe 'Clearstream API', type: :request do
  describe 'POST /api/v1/messages' do
    let(:valid_attributes) do
      {
        'from_email': 'alice@gmail.com',
        'to_email':   'bob@gmail.com',
        'subject':    'A test from Rails',
        'content':    'How R U?'
      }.to_json
    end

    context 'when request is valid' do
      before { post '/api/v1/messages', headers: valid_headers, params: valid_attributes }

      it 'sends sg_email' do
        expect(json['response_status_code']).to eq(nil)
      end

      it 'returns status code 202' do
        expect(response).to have_http_status(202)
      end
    end

    context 'when the request header is missing basic auth info' do
      before { post '/api/v1/messages', headers: invalid_headers, params: valid_attributes }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end

    context 'when the request auth header is good, but the body is invalid' do
      let(:invalid_attributes) { { from_email: nil }.to_json }
      before { post '/api/v1/messages', headers: valid_headers, params: invalid_attributes }

      it 'returns status code 422' do
        expect(response.status).to eq 422
      end

      it 'returns a validation failure message' do
        expect(json['error'])
          .to match('from_email' => ["can't be blank", 'is invalid'],
                    'to_email'   => ["can't be blank", 'is invalid', 'should be different than from_email'],
                    'subject'    => ["can't be blank"],
                    'content'    => ["can't be blank"])
      end
    end
  end
end

# rubocop:enable Layout/AlignHash
