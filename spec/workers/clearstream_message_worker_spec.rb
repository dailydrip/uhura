# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ClearstreamMessageWorker do
  before do
    Sidekiq::Worker.clear_all
  end

  describe '.perform' do
    let(:clearstream_vo) do
      {
        "resource": 'messages',
        "message_id": 28,
        "mobile_number": '+17707651573‬',
        "message_header": 'Leadership Team',
        "message_body": 'Come in now for 50% off all rolls!',
        "subscribers": '+17707651573‬',
        "schedule": false,
        "send_to_fb": false,
        "send_to_tw": false
      }
    end

    context 'with a clearstream_vo' do
      it 'calls the ClearstreamHandler' do
        expect(ClearstreamHandler).to receive(:send_msg).once
        subject.perform(clearstream_vo)
      end
    end

    context 'with a nil clearstream_vo' do
      it 'raises a ClearstreamClient::BaseClient::APIError' do
        stub_request(:any, /api.getclearstream.com/)
          .to_raise(ClearstreamClient::BaseClient::APIError)

        expect do
          ClearstreamMessageWorker.perform_async(clearstream_vo)
        end.to raise_error(ClearstreamClient::BaseClient::APIError)
      end
    end
  end
end
