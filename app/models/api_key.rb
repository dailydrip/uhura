# frozen_string_literal: true

class ApiKey < ApplicationRecord
  belongs_to :manager
  has_secure_token :auth_token

  validates :manager, presence: true
  validates :auth_token, presence: true

  before_validation :set_auth_token, on: :create

  private

  def set_auth_token
    self.auth_token = SecureRandom.hex(10)
  end
end
