# frozen_string_literal: true

class Manager < ApplicationRecord
  # A Manager (a/k/a "App") is the parent of all other objects in the data model.

  NotInSession = Class.new(StandardError)

  validates :name, presence: true
  validates :public_token, presence: true

  has_many :api_keys, dependent: :destroy
  has_many :message_vos

  before_validation :set_public_token, on: :create  # Needed to pass validations
  before_create :set_public_token                   # Needed b/c on: :create does not always save properly

  def api_key
    ApiKey.find_by(manager_id: id)
  end

  private

  def set_public_token
    self.public_token ||= SecureRandom.hex(10)
  end
end
