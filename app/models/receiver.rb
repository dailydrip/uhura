class Receiver < ApplicationRecord

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :mobile_number, presence: true

  def to_name
    "#{self.first_name} #{self.last_name}".strip
  end
end
