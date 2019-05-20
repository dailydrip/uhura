# frozen_string_literal: true

# This is a value object that also performs data presence validation
class MessageParamsVo < BaseClass
  include ActiveModel::Model
  include ActiveModel::Validations

  validates :public_token, presence: true
  validates :receiver_sso_id, format: { with: /\A\d+\z/, message: 'integers only' }
  validates :email_subject, presence: true
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


  def ActiveModel.initialize(*args)
    super
  end

  def my_attrs
    self.my_attributes = {} if self.my_attributes.nil?
    self.attributes.select { |attr| attr != :validation_context }.each do |i|
      self.my_attributes[i] = self.send(i.to_s)
    end
    self.my_attributes.delete(:my_attributes)
    self.my_attributes
  end

  def email_message_sections
    if self.email_message
      if @email_message['section1'].blank?
        errors.add(:value, 'email_message missing sections. First section should be named "section1".')
      end
    end
  end
end
