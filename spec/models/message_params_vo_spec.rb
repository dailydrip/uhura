# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MessageParamsVo, type: :model do
  describe 'fields' do
    it { is_expected.to respond_to(:public_token) }
    it { is_expected.to respond_to(:receiver_sso_id) }
    it { is_expected.to respond_to(:email_subject) }
    it { is_expected.to respond_to(:email_message) }
    it { is_expected.to respond_to(:email_message_sections) }
    it { is_expected.to respond_to(:template_id) }
    it { is_expected.to respond_to(:sms_message) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:public_token) }
    it { is_expected.to validate_presence_of(:email_subject) }
    it { is_expected.to validate_presence_of(:email_message) }
    it { is_expected.to validate_presence_of(:template_id) }
    it { is_expected.to validate_presence_of(:sms_message) }

    def message_params(new_params = {})
      {
        public_token: '82a1782d202d49efef87',
        receiver_sso_id: 88_543_890,
        email_subject: 'Picnic Saturday',
        email_message: {
          header: 'Rock Slide',
          section1: 'Plant a memory, plant a tree, do it today for tomorrow.',
          button: 'Brush'
        },
        template_id: 'd-f986df533e514f978f4460bedca50db0',
        sms_message: 'Come in now for 50% off all rolls!'
      }.merge(new_params)
    end

    context 'initialization' do
      it 'must have valid public_token' do
        message_params_vo = MessageParamsVo.new(message_params(public_token: nil))
        expect(message_params_vo.valid?).to eq(false)
      end

      it 'must have valid receiver_sso_id' do
        message_params_vo = MessageParamsVo.new(message_params(receiver_sso_id: nil))
        expect(message_params_vo.valid?).to eq(false)
      end

      it 'must have valid email_subject' do
        message_params_vo = MessageParamsVo.new(message_params(email_subject: nil))
        expect(message_params_vo.valid?).to eq(false)
      end

      it 'must have at least one section in email_message' do
        message_params_vo = MessageParamsVo.new(
          message_params(
            email_message: {
            }
          )
        )
        expect(message_params_vo.valid?).to eq(false)
      end
      it 'must have valid email_message' do
        message_params_vo = MessageParamsVo.new(message_params(email_message: nil))
        expect(message_params_vo.valid?).to eq(false)
      end

      it 'must have valid template_id' do
        message_params_vo = MessageParamsVo.new(message_params(template_id: nil))
        expect(message_params_vo.valid?).to eq(false)
      end

      it 'must have valid sms_message' do
        message_params_vo = MessageParamsVo.new(message_params(sms_message: nil))
        expect(message_params_vo.valid?).to eq(false)
      end

      describe 'when message params are valid' do
        it 'is valid' do
          message_params_vo = MessageParamsVo.new(message_params)
          expect(message_params_vo.valid?).to eq(true)
        end
      end
    end
  end
end
