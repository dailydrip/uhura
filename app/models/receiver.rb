class Receiver < ApplicationRecord
  PHONE_REGEXP = /\A(?:\+?\d{1,3}\s*-?)?\(?(?:\d{3})?\)?[- ]?\d{3}[- ]?\d{4}\z/

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :mobile_number, format: { with: PHONE_REGEXP }

  def to_name
    "#{self.first_name} #{self.last_name}".strip
  end
end
