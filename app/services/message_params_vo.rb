# frozen_string_literal: true

# This is a value object that also performs data presence validation
class MessageParamsVo < BaseClass
  InvalidMessageError = Class.new(StandardError)

  include ActiveModel::Model
  include ActiveModel::Validations

  validates :public_token, presence: true
  validates :receiver_sso_id, format: { with: /\A\d+\z/, message: 'integers only' }
  validates :email_subject, presence: true
  validates :email_message, presence: true
  validate :email_message_sections
  validates :template_id, presence: true
  validates :sms_message, presence: true

  attr_accessor :public_token,
                :receiver_sso_id,
                :email_subject,
                :email_message,
                :template_id,
                :sms_message,
                :my_attributes

  def initialize(*args)
    super(args[0])
    raise InvalidMessageError, 'invalid message_params_vo' unless valid?
  end

  def email_message_sections
    if email_message
      if @email_message[:section1].blank?
        errors.add(:value, 'email_message missing sections. First section should be named "section1".')
      end
    end
  end

  def message_params
    {
        public_token: self.public_token,
        receiver_sso_id: self.receiver_sso_id,
        email_subject: self.email_subject,
        email_message: self.email_message,
        template_id: self.template_id,
        sms_message: self.sms_message
    }
  end
end
