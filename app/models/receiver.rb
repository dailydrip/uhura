# frozen_string_literal: true

class Receiver < ApplicationRecord
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :mobile_number, presence: true

  def to_name
    "#{first_name} #{last_name}".strip
  end

  def self.find_or_enroll(message_vo)
    receiver = Receiver.find_by(receiver_sso_id: message_vo.receiver_sso_id)
    if receiver.nil?
      # Create receiver
      receiver = Receiver.create!(
          receiver_sso_id: message_vo.receiver_sso_id,
          email: message_vo.receiver_email
      )
      # Lookup sso user by email and assign delivery preference, fname, lname

    end
    receiver
  end
end
