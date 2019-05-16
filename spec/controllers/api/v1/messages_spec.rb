# frozen_string_literal: true

# rubocop:disable Layout/AlignHash

require 'rails_helper'

RSpec.describe 'Messages API', type: :request do
  describe 'POST /api/v1/messages' do
    let(:valid_attributes) do
      # receiver = create(:receiver)
      # manager = create(:manager)
      # {
        # "public_token": manager.public_token,
        # "receiver_sso_id": receiver.id,
        # "email_subject": "Picnic Saturday",
        # "email_message": {
          # "header": "Dragon Rage",
          # "section1": "imagine you are writing an email. you are in front of the computer. you are operating the computer, clicking a mouse and typing on a keyboard, but the message will be sent to a human over the internet. so you are working before the computer, but with a human behind the computer.",
          # "button": "Count me in!"
        # },
        # "template_id": "d-f986df533e514f978f4460bedca50db0",
        # "sms_message": "Come in now for 50% off all rolls!"
      # }.to_json
    end


    context 'when it is not authorized' do
      it 'returns 401 with an error in the body' do
        post '/api/v1/messages', headers: valid_headers, params: valid_attributes
        expect(response.status).to eq (401)
        expect(response.parsed_body).to eq({"error"=>"This Api Key does not exist."})
      end
    end


    context 'when it is authorized' do
      let(:invalid_headers) do
        # receiver = create(:receiver)
        # manager = create(:manager)
        # {
          # "public_token": manager.public_token,
          # "receiver_sso_id": receiver.id,
          # "email_subject": "Picnic Saturday",
          # "email_message": {
            # "header": "Dragon Rage",
            # "section1": "imagine you are writing an email. you are in front of the computer. you are operating the computer, clicking a mouse and typing on a keyboard, but the message will be sent to a human over the internet. so you are working before the computer, but with a human behind the computer.",
            # "button": "Count me in!"
          # },
          # "template_id": "d-f986df533e514f978f4460bedca50db0",
          # "sms_message": "Come in now for 50% off all rolls!"
        # }.to_json
      end

      let(:invalid_attributes) do
        # receiver = create(:receiver)
        # manager = create(:manager)
        # {
          # "public_token": manager.public_token,
          # "receiver_sso_id": receiver.id,
          # "email_subject": "Picnic Saturday",
          # "email_message": {
            # "header": "Dragon Rage",
            # "section1": "imagine you are writing an email. you are in front of the computer. you are operating the computer, clicking a mouse and typing on a keyboard, but the message will be sent to a human over the internet. so you are working before the computer, but with a human behind the computer.",
            # "button": "Count me in!"
          # },
          # "template_id": "d-f986df533e514f978f4460bedca50db0",
          # "sms_message": "Come in now for 50% off all rolls!"
        # }.to_json
      end


      it 'returns 401 with an error in the body' do
        post '/api/v1/messages', headers: valid_headers, params: valid_attributes
        expect(response.status).to eq (401)
        expect(response.parsed_body).to eq({"error"=>"This Api Key does not exist."})
      end
    end

    context 'when it has right public token and authorization' do
    end

    context 'when it does not have Xteam id in the header' do
    end


    context 'when request is valid' do
      before do
        stub_request(:any, /api.getclearstream.com/).to_return(body: "<pu there whatever you think it will return>", status: 200, headers: { 'Content-Length' => 3 })
        stub_request(:any, /api.sendgrid.com/).to_return(body: "<put  here whatever you think it will return>", status: 200, headers: { 'Content-Length' => 3 })
      end

      let(:valid_headers){

      }

      let(:valid_attributes){

      }

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

# rubocop:enable Layout/AlignHash
