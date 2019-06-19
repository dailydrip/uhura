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
                :email_options,
                :template_id,
                :sms_message,
                :my_attributes

  def initialize(*args)
    super(args[0])
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
      public_token: @public_token,
      receiver_sso_id: @receiver_sso_id,
      email_subject: @email_subject,
      email_message: @email_message,
      email_options: @email_options,
      template_id: @template_id,
      sms_message: @sms_message
    }
  end
end
