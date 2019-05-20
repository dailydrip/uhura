# frozen_string_literal: true

class Receiver < ApplicationRecord
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :mobile_number, presence: true

  def to_name
    "#{first_name} #{last_name}".strip
  end
end
