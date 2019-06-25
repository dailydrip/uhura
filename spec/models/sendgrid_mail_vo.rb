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

  describe '#text_content' do
    it 'returns the right text content' do
      text_content = SendgridMailVo.new(template_id: 3,
                                        dynamic_template_data: { header: 'header' },
                                        subject: 'Subject',
                                        message_id: '123',
                                        from: 'someone@example.com',
                                        to_name: 'Person',
                                        to: 'example@example.com').text_content
      expect(text_content).to eq "header\n\n"

      text_content = SendgridMailVo.new(template_id: 3,
                                        dynamic_template_data: {},
                                        subject: 'Subject',
                                        message_id: '123',
                                        from: 'someone@example.com',
                                        to_name: 'Person',
                                        to: 'example@example.com').text_content
      expect(text_content).to eq "\n\n"
    end
  end

  describe '.mail' do
    it 'returns the mail information' do
      vo = SendgridMailVo.new(template_id: 3,
                              dynamic_template_data: { header: 'header' },
                              subject: 'Subject',
                              message_id: '123',
                              from: 'someone@example.com',
                              to_name: 'Person',
                              to: 'example@example.com').vo

      mail = SendgridMailVo.mail(vo[:mail_vo])

      expect(mail).to be_a(SendGrid::Mail)
      expect(mail.subject).to eq 'Subject'
      expect(mail.from['email']).to eq 'someone@example.com'
    end
  end

  describe '.add_options' do
    it 'adds options for the email' do
      vo = SendgridMailVo.new(template_id: 3,
                              dynamic_template_data: { header: 'header' },
                              subject: 'Subject',
                              message_id: '123',
                              email_options: {
                                cc: ['example@example.com'],
                                bcc: ['bcc1@example.com', 'bcc2@example.com'],
                                reply_to: 'reply-to@example.com',
                                send_at: 1_231_231,
                                batch_id: 'id'
                              },
                              from: 'someone@example.com',
                              to_name: 'Person',
                              to: 'example@example.com').vo

      mail = SendGrid::Mail.new
      personalization = Personalization.new
      m_and_p = SendgridMailVo.add_options(vo[:mail_vo], mail, personalization)

      mail = m_and_p[:mail]
      personalization = m_and_p[:personalization]

      expect(mail).to be_a(SendGrid::Mail)
      expect(mail.send_at).to eq 1_231_231
      expect(mail.batch_id).to eq 'id'

      expect(personalization).to be_a(SendGrid::Personalization)
      expect(personalization.ccs).to eq [{ 'email' => 'example@example.com' }]
      expect(personalization.bccs).to eq [{ 'email' => 'bcc1@example.com' }, { 'email' => 'bcc2@example.com' }]
    end
  end
end
