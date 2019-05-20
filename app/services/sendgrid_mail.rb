# frozen_string_literal: true

require 'sendgrid-ruby'
include SendGrid

class SendgridMail
  Invalid = Class.new(StandardError)
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :from,
                :to,
                :to_name,
                :subject,
                :template_id,
                :dynamic_template_data

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

  def get
    raise Invalid, errors.full_messages unless valid?

    mail = SendGrid::Mail.new
    mail.template_id = @template_id
    mail.from = Email.new(email: @from)
    mail.subject = @subject
    personalization = Personalization.new
    personalization.add_to(Email.new(email: @to, name: @to_name))
    personalization.add_dynamic_template_data(@dynamic_template_data)
    mail.add_personalization(personalization)
    mail
  end
end
