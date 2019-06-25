# frozen_string_literal: true

require 'sendgrid-ruby'
include SendGrid

class SendgridMailVo
  InvalidEmailOptionError = Class.new(StandardError)
  Invalid = Class.new(StandardError)
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :from,
                :to,
                :to_name,
                :subject,
                :email_options,
                :template_id,
                :dynamic_template_data,
                :message_id,
                :personalizations

  validates :template_id,
            :from,
            :subject,
            :to,
            :to_name,
            :dynamic_template_data,
            presence: true

  def initialize(*args)
    super
    @dynamic_template_data = JSON.parse(@dynamic_template_data.to_json)
  end

  # The receiver is the Highlands SSO ID
  def receiver_sso_id=(receiver_sso_id)
    receiver = Receiver.find_by(receiver_sso_id: receiver_sso_id)
    if receiver
      @receiver_sso_id = receiver_sso_id
      @to = receiver.email
      @to_name = receiver.to_name
    end
  end

  attr_reader :receiver_sso_id

  def vo
    raise Invalid, errors.full_messages unless valid?

    mail_vo = {
      template_id: @template_id,
      from: @from,
      subject: @subject,
      to: @to,
      to_name: @to_name,
      dynamic_template_data: @dynamic_template_data,
      personalizations: @personalizations,
      email_options: JSON.parse(@email_options.to_json)
    }

    { mail_vo: mail_vo, message_id: @message_id }
  end

  def self.add_options(mail_vo, mail, personalization)
    email_options = JSON.parse(mail_vo[:email_options].to_json) # Convert from ActionController::Parameters
    email_options.each do |k, value|
      case k
      when 'cc'
        personalization = extract_cc(personalization, value)
      when 'bcc'
        personalization = extract_bcc(personalization, value)
      when 'reply_to'
        mail.reply_to = extract_reply_to(value)
      when 'send_at'
        mail.send_at = value
      when 'batch_id'
        mail.batch_id = value
      else
        raise InvalidEmailOptionError, "unknown email option received {#{k}: #{value}}"
      end
    end
    { mail: mail, personalization: personalization }
  end

  def self.extract_cc(personalization, value)
    # ["recipient1@example.com <Alice Recipient>","recipient2@example.com"]
    value.each do |i|
      cc_maybe_name_ary = i.strip.gsub('  ', ' ').split(' ')
      cc = cc_maybe_name_ary[0]
      cc_name = cc_maybe_name_ary[1..-1].join(' ')[1..-2] if cc_maybe_name_ary.size > 1
      personalization.add_cc(Email.new(email: cc, name: cc_name))
    end
    personalization
  end

  def self.extract_bcc(personalization, value)
    # ["recipient3@example.com","recipient4@example.com <Bob Recipient>"]
    value.each do |i|
      bcc_maybe_name_ary = i.strip.gsub('  ', ' ').split(' ')
      bcc = bcc_maybe_name_ary[0]
      bcc_name = bcc_maybe_name_ary[1..-1].join(' ')[1..-2] if bcc_maybe_name_ary.size > 1
      personalization.add_bcc(Email.new(email: bcc, name: bcc_name))
    end
    personalization
  end

  def self.extract_reply_to(value)
    reply_to_maybe_name_ary = value.strip.gsub('  ', ' ').split(' ')
    reply_to = reply_to_maybe_name_ary[0]
    reply_to_name = reply_to_maybe_name_ary[1..-1].join(' ')[1..-2] if reply_to_maybe_name_ary.size > 1
    Email.new(email: reply_to, name: reply_to_name)
  end

  def self.mail(mail_vo)
    mail = SendGrid::Mail.new
    personalization = Personalization.new
    if mail_vo[:email_options]
      m_and_p = add_options(mail_vo, mail, personalization)
      mail = m_and_p[:mail]
      personalization = m_and_p[:personalization]
    end
    mail = base_email_attributes(mail, mail_vo)

    personalization = extract_personalization(personalization, mail_vo)
    personalization = extract_custom_args(personalization, mail_vo)

    mail.add_personalization(personalization)
    mail
  end

  def self.base_email_attributes(mail, mail_vo)
    mail.template_id = mail_vo[:template_id]
    mail.from = Email.new(email: mail_vo[:from])
    mail.subject = mail_vo[:subject]
    mail
  end

  def self.extract_personalization(personalization, mail_vo)
    personalization.add_to(Email.new(email: mail_vo[:to], name: mail_vo[:to_name]))
    personalization.add_dynamic_template_data(mail_vo[:dynamic_template_data]) if mail_vo[:dynamic_template_data]
    personalization
  end

  def self.extract_custom_args(personalization, mail_vo)
    uhura_msg_id = mail_vo[:personalizations][0][:custom_args][:uhura_msg_id] if mail_vo[:personalizations]
    personalization.add_custom_arg(CustomArg.new(key: 'uhura_msg_id', value: uhura_msg_id || ''))
    personalization
  end

  def text_content
    content = []
    content << @dynamic_template_data['header']
    content << @dynamic_template_data
               .each_pair.select { |k, v| v if k.to_s.include?('section') }
               .map { |i| i[1] }
    content.join("\n\n")
  end
end
