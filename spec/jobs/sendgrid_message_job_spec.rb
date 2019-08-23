# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SendgridMessageJob, type: :job do
  before do
    Sidekiq::Worker.clear_all
  end

  describe '.perform' do
    let(:sendgrid_vo) do
      {
        "mail": {
          "from": {
            "email": 'app1@highlands.org',
            "name": nil
          },
          "subject": 'Picnic Saturday',
          "personalizations": [
            {
              "to": [
                {
                  "email": 'bob.replace.me@gmail.com',
                  "name": 'Bob Brown'
                }
              ],
              "dynamic_template_data": {
                "header": 'Dragon Rage',
                "section1": 'imagine you are writing an email. you are in front of the computer. you are operating the computer, clicking a mouse and typing on a keyboard, but the message will be sent to a human over the internet. so you are working before the computer, but with a human behind the computer.',
                "button": 'Count me in!',
                "email_subject": 'Picnic Saturday'
              }
            }
          ],
          "contents": [],
          "attachments": [],
          "template_id": 'd-0ce0d614007d4a72b8242838451e9a65',
          "sections": {},
          "headers": {},
          "categories": [],
          "custom_args": {},
          "send_at": nil,
          "batch_id": nil,
          "asm": nil,
          "ip_pool_name": nil,
          "mail_settings": nil,
          "tracking_settings": nil,
          "reply_to": nil
        },
        "message_id": 32
      }
    end

    context 'with a sendgrid_vo' do
      it 'calls the SendgridHandler' do
        stub_request(:post, 'https://api.sendgrid.com/v3/mail/send')
          .with(
            body: '"null"',
            headers: {
              'Accept' => 'application/json',
              'Authorization' => "Bearer #{ENV['SENDGRID_API_KEY']}",
              'Content-Type' => 'application/json'
            }
          ).to_return(status: 200, body: '', headers: {})

        expect(SendgridHandler).to receive(:send_msg).once
        subject.perform(sendgrid_vo)
      end
    end

    context 'with a nil sendgrid_vo' do
      it 'raises a ClearstreamClient::BaseClient::APIError' do
        stub_request(:any, /api.sendgrid.com/)
          .to_raise(ClearstreamClient::BaseClient::APIError)

        expect do
          sendgrid_vo = nil
          SendgridMessageJob.perform_later(sendgrid_vo)
        end.to raise_error(NoMethodError)
      end
    end
  end
end
