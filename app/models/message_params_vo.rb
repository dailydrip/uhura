# frozen_string_literal: true

# This is a value object that also performs data presence validation
class MessageParamsVo < BaseClass
  include ActiveModel::Model
  include ActiveModel::Validations

  validates :public_token, presence: true
  validates :receiver_sso_id, numericality: { only_integer: true }
  validates :email_subject, presence: true
  validates :email_message, presence: true
  validate :email_message_sections
  validates :template_id, presence: true
  validates :sms_message, presence: true

  validate :email_options_check

  attr_accessor :public_token,
                :receiver_sso_id,
                :from_email,
                :email_subject,
                :email_message,
                :email_options,
                :template_id,
                :sms_message

  def initialize(*args)
    super(args[0])
  end

  # FIXME: We should not hardcode the section names.
  # Ideally, we would look up the sections at the sendgrid api
  # by the template id and raise if any of them are missing.
  def email_message_sections
    if email_message
      errors.add(:value, 'email_message missing sections') if JSON.parse(@email_message.to_json).keys.size.eql?(0)
    end
  end

  def message_params
    {
      public_token: @public_token,
      receiver_sso_id: @receiver_sso_id,
      from_email: @from_email,
      email_subject: @email_subject,
      email_message: @email_message,
      email_options: @email_options,
      template_id: @template_id,
      sms_message: @sms_message
    }
  end

  def email_option_check(email_option)
    errors.add(:email_option, "invalid email: #{email_option}") unless email_option.match(RFC5233_EMAIL_REGEXP)
  end

  # Example: ["Bob Brown <bob@example.com>", "alice@example.com"]
  # send_at and batch_id do not have email data (only cc, bcc)
  def email_options_check
    if email_options
      JSON.parse(email_options.to_json).slice('cc', 'bcc').each do |k, v|
        if v.class.eql?(Array)
          v.each { |i| email_option_check(i) }
        else
          errors.add(:email_option, "expected an array (#{k}: #{v})")
        end
      end
    end
  end
end
