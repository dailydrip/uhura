# frozen_string_literal: true

class Receiver < ApplicationRecord
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :receiver_sso_id, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :mobile_number, presence: true
  validates :preferences, presence: true

  def to_name
    "#{first_name} #{last_name}".strip
  end

  def self.find_or_enroll(message_vo)
    receiver = Receiver.find_by(receiver_sso_id: message_vo.receiver_sso_id)
    if receiver.nil?
      # Create receiver
      receiver = Receiver.create!(
        receiver_sso_id: message_vo.receiver_sso_id,
        first_name: message_vo.first_name,
        last_name: message_vo.last_name,
        email: message_vo.email,
        mobile_number: message_vo.mobile_number,
        preferences: message_vo.convert_preferences
      )
      # Lookup sso user by email and assign delivery preference, fname, lname
    else
      if !receiver.user_attributes.eql?(message_vo.user_attributes)
        receiver = Receiver.update!(message_vo.user_attributes)
      end
    end
    receiver
  end

  def user_attributes
    self.attributes.except('id', 'created_at', 'updated_at')
  end

end
