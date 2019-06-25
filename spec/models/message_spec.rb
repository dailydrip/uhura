# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to(:msg_target) }
    it { is_expected.to belong_to(:sendgrid_msg).optional }
    it { is_expected.to belong_to(:clearstream_msg).optional }
    it { is_expected.to belong_to(:manager) }
    it { is_expected.to belong_to(:receiver) }
    it { is_expected.to belong_to(:team) }
    it { is_expected.to belong_to(:template) }
  end

  describe 'fields' do
    it { is_expected.to respond_to(:app) }
    it { is_expected.to respond_to(:manager) }
    it { is_expected.to respond_to(:app_id) }
    it { is_expected.to respond_to(:manager_id) }
  end

  describe '.message_and_status' do
    context 'when we dot not have a target' do
      let!(:message) { create(:message) }
      it 'raises an error if we dont have a target' do
        expect do
          Message.message_and_status(message.id)
        end.to raise_error(Message::InvalidMessageError, /invalid_message__missing_target/)
      end
    end

    context 'when we dot have a target' do
      let!(:message) { create(:message, msg_target: create(:msg_target, name: 'Sendgrid')) }
      it 'raises an error if we dont have a target' do
        result = Message.message_and_status(message.id)

        expect(result[:message].id).to eq message.id
        expect(result[:status]).to eq(sendgrid_msg_status: nil, clearstream_msg_status: nil)
      end
    end
  end
end
