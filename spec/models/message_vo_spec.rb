# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MessageVo, type: :model do
  describe 'fields' do
    let(:email_message) do
      {
        header: 'Rock Slide',
        section1: 'Plant a memory, plant a tree, do it today for tomorrow.',
        button: 'Brush'
      }
    end

    let(:message_params_vo) do
      MessageParamsVo.new(
        public_token: '82a1782d202d49efef87',
        receiver_sso_id: '88543890',
        email_subject: 'Picnic Saturday',
        email_message: email_message,
        template_id: 'd-f986df533e514f978f4460bedca50db0',
        sms_message: 'Come in now for 50% off all rolls!'
      )
    end

    let(:manager_team_vo) do
      ManagerTeamVo.new(
        manager_id: 1,
        manager_name: 'Picnic Saturday',
        manager_email: 'app1@highlands.org',
        team_name: 'Leadership Team'
      )
    end

    subject { MessageVo.new(message_params_vo, manager_team_vo) }

    it { is_expected.to respond_to(:manager_id) }
    it { is_expected.to respond_to(:manager_email) }
    it { is_expected.to respond_to(:manager_name) }
    it { is_expected.to respond_to(:team_name) }
    it { is_expected.to respond_to(:receiver_sso_id) }
    it { is_expected.to respond_to(:email_subject) }
    it { is_expected.to respond_to(:email_message) }
    it { is_expected.to respond_to(:template_id) }
    it { is_expected.to respond_to(:mobile_number) }
    it { is_expected.to respond_to(:first) }
    it { is_expected.to respond_to(:last) }
    it { is_expected.to respond_to(:email) }
    it { is_expected.to respond_to(:lists) }
    it { is_expected.to respond_to(:receiver_preferences) }
    it { is_expected.to respond_to(:template_found) }
  end

  describe 'validations' do
    let(:email_message) do
      {
        header: 'Rock Slide',
        section1: 'Plant a memory, plant a tree, do it today for tomorrow.',
        button: 'Brush'
      }
    end

    let(:message_params_vo) do
      MessageParamsVo.new(
        public_token: '82a1782d202d49efef87',
        receiver_sso_id: '88543890',
        email_subject: 'Picnic Saturday',
        email_message: email_message,
        template_id: 'd-f986df533e514f978f4460bedca50db0',
        sms_message: 'Come in now for 50% off all rolls!'
      )
    end
    let(:bogus_message_params_vo) do
      MessageParamsVo.new(
        public_token: nil,
        receiver_sso_id: '88543890',
        email_subject: 'Picnic Saturday',
        email_message: email_message,
        template_id: 'd-f986df533e514f978f4460bedca50db0',
        sms_message: 'Come in now for 50% off all rolls!'
      )
    end

    let(:manager_team_vo) do
      ManagerTeamVo.new(
        manager_id: 1,
        manager_name: 'Picnic Saturday',
        manager_email: 'app1@highlands.org',
        team_name: 'Leadership Team'
      )
    end
    let(:bogus_manager_team_vo) do
      ManagerTeamVo.new(
        manager_id: nil,
        manager_name: 'Picnic Saturday',
        manager_email: 'app1@highlands.org',
        team_name: 'Leadership Team'
      )
    end

    context 'initialization' do
      it 'must have valid message_params_vo' do
        expect do
          MessageVo.new(bogus_message_params_vo, manager_team_vo)
        end.to raise_error(MessageVo::InvalidMessageError, /invalid message_params_vo/)
      end

      it 'must have valid manager_team_vo' do
        expect do
          MessageVo.new(message_params_vo, bogus_manager_team_vo)
        end.to raise_error(MessageVo::InvalidManagerTeamError, /invalid manager_team_vo/)
      end
    end

    context 'when both sets of parameter value inputs are valid' do
      it 'does not raise any exception' do
        expect do
          MessageVo.new(message_params_vo, manager_team_vo)
        end.to_not raise_error
      end

      it 'initializes everything' do
        message_vo = MessageVo.new(message_params_vo, manager_team_vo)
        expect(message_vo.sms_message).to eq 'Come in now for 50% off all rolls!'
        expect(message_vo.manager_name).to eq 'Picnic Saturday'
        expect(message_vo.email_subject).to eq 'Picnic Saturday'
        expect(message_vo.public_token).to eq '82a1782d202d49efef87'
        expect(message_vo.manager_email).to eq 'app1@highlands.org'
        expect(message_vo.receiver_sso_id).to eq '88543890'
      end
    end
  end
end
