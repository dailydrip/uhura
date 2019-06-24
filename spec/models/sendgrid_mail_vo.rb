# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SendgridMailVo do
  describe 'fields' do
    it { is_expected.to respond_to(:from) }
    it { is_expected.to respond_to(:to) }
    it { is_expected.to respond_to(:to_name) }
    it { is_expected.to respond_to(:subject) }
    it { is_expected.to respond_to(:email_options) }
    it { is_expected.to respond_to(:template_id) }
    it { is_expected.to respond_to(:dynamic_template_data) }
    it { is_expected.to respond_to(:message_id) }
    it { is_expected.to respond_to(:personalizations) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:from) }
    it { is_expected.to validate_presence_of(:to) }
    it { is_expected.to validate_presence_of(:to_name) }
    it { is_expected.to validate_presence_of(:subject) }
    it { is_expected.to validate_presence_of(:template_id) }
    it { is_expected.to validate_presence_of(:dynamic_template_data) }
  end

  describe '#vo' do
    it 'returns the right vo' do
      vo = SendgridMailVo.new(template_id: 3,
                              dynamic_template_data: 'dynamic',
                              subject: 'Subject',
                              message_id: '123',
                              from: 'someone@example.com',
                              to_name: 'Person',
                              to: 'example@example.com').vo
      expect(vo[:mail_vo]).not_to be_nil
      expect(vo[:mail_vo][:template_id]).to eq 3
      expect(vo[:mail_vo][:subject]).to eq 'Subject'
      expect(vo[:mail_vo][:from]).to eq 'someone@example.com'
      expect(vo[:mail_vo][:to_name]).to eq 'Person'
      expect(vo[:mail_vo][:dynamic_template_data]).to eq 'dynamic'
      expect(vo[:mail_vo][:to]).to eq 'example@example.com'
      expect(vo[:message_id]).to eq '123'
    end
  end
end
