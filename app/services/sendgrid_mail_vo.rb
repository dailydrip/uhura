# frozen_string_literal: true

require 'sendgrid-ruby'
include SendGrid

class SendgridMailVo
  Invalid = Class.new(StandardError)
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :from,
                :to,
                :to_name,
                :subject,
                :template_id,
                :dynamic_template_data,
                :message_id

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

  # rubocop:disable Naming/AccessorMethodName
  def get_vo
    raise Invalid, errors.full_messages unless valid?

    mail_vo = {
      template_id: @template_id,
      from: @from,
      subject: @subject,
      to: @to,
      to_name: @to_name,
      dynamic_template_data: @dynamic_template_data
    }
    # Bug in Sendgrid's add_custom_arg.  Following will throw error "no implicit conversion of String into Hash"
    # mail.add_custom_arg(Hash["custom_arg" => {message_id: @message_id}])
    { mail_vo: mail_vo, message_id: @message_id }
  end

  def self.get_mail(mail_vo)
    mail = SendGrid::Mail.new
    mail.template_id = mail_vo[:template_id]
    mail.from = Email.new(email: mail_vo[:from])
    mail.subject = mail_vo[:subject]
    personalization = Personalization.new
    personalization.add_to(Email.new(email: mail_vo[:to], name: mail_vo[:to_name]))
    personalization.add_dynamic_template_data(mail_vo[:dynamic_template_data])
    mail.add_personalization(personalization)
    mail
  end
  # rubocop:enable Naming/AccessorMethodName

  # rubocop:disable all
  def text_content
    content = []
    content << @dynamic_template_data['header']
    content << @dynamic_template_data
                   .each_pair.select { |k, v| v if k.to_s.include?('section') }
                   .map { |i| i[1] }
    content.join("\n\n")
  end
  # rubocop:enable all
end
