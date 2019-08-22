# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'Associations' do
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
    context 'with a valid message' do
      let!(:message) { create(:message) }

      it 'has valid attributes' do
        message_and_status = Message.message_and_status(message.id)
        expect(message_and_status[:message]).to_not be_nil
        expect(message_and_status[:status][:sendgrid_msg_status]).to eq('accepted')
        expect(message_and_status[:status][:clearstream_msg_status]).to eq('QUEUED')
      end
    end
  end

  describe '.status' do
    context 'with a valid message' do
      let!(:message) { create(:message) }

      it 'has valid attributes' do
        expect(message.status[:sendgrid]).to eq('accepted')
        expect(message.status[:clearstream]).to eq('QUEUED')
      end
    end
  end
end
