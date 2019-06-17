# frozen_string_literal: true

# rubocop:disable all
require 'rails_helper'

RSpec.describe MessageParamsVo, type: :model do
  describe 'validations' do
    def message_params(new_params = {})
      {
        public_token: '82a1782d202d49efef87',
        receiver_sso_id: '88543890',
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
        expect do
          MessageParamsVo.new(message_params(public_token: nil))
        end.to raise_error(MessageParamsVo::InvalidMessageError, /invalid message_params_vo/)
      end

      it 'must have valid receiver_sso_id' do
        expect do
          MessageParamsVo.new(message_params(receiver_sso_id: nil))
        end.to raise_error(MessageParamsVo::InvalidMessageError, /invalid message_params_vo/)
      end

      it 'must have valid email_subject' do
        expect do
          MessageParamsVo.new(message_params(email_subject: nil))
        end.to raise_error(MessageParamsVo::InvalidMessageError, /invalid message_params_vo/)
      end

      it 'must have valid section1 in email_message' do
        expect do
          MessageParamsVo.new(message_params(email_message: {
                                               header: 'Rock Slide',
                                               section1: nil,
                                               button: 'Brush'
                                             }))
        end.to raise_error(MessageParamsVo::InvalidMessageError, /invalid message_params_vo/)
      end
      it 'must have valid email_message' do
        expect do
          MessageParamsVo.new(message_params(email_message: nil))
        end.to raise_error(MessageParamsVo::InvalidMessageError, /invalid message_params_vo/)
      end

      it 'must have valid template_id' do
        expect do
          MessageParamsVo.new(message_params(template_id: nil))
        end.to raise_error(MessageParamsVo::InvalidMessageError, /invalid message_params_vo/)
      end

      it 'must have valid sms_message' do
        expect do
          MessageParamsVo.new(message_params(sms_message: nil))
        end.to raise_error(MessageParamsVo::InvalidMessageError, /invalid message_params_vo/)
      end

      describe 'when message params are valid' do
        it 'does not raise any exception' do
          expect do
            MessageParamsVo.new(message_params).not_to raise_error
          end
        end
      end
    end
  end
end
# rubocop:enable all