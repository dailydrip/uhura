# frozen_string_literal: true

class ReturnVo
  Invalid = Class.new(StandardError)

  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :value, :error

  validate :concistency_check

  def ActiveModel.initialize(*args)
    super
    validate!
  end

  def get
    raise Invalid, errors.full_messages unless valid?

    { value: @value, error: @error }
  end

  def error?
    !@error.nil?
  end

  def status
    # If there is a status, then return that else :unprocessable_entity
    @value[:status] || unprocessable_entity
  end

  def self.new_value(value_hash)
    new(value: return_accepted(value_hash), error: nil)
  end

  def self.new_err(err)
    new(value: nil, error: return_error(err, :unprocessable_entity))
  end

  private

  def concistency_check
    if error.nil? && value.nil?
      errors.add(:value, 'cannot be nil when error is nil')
      errors.add(:error, 'cannot be nil when value is nil')
    end
    if !error.nil? && !value.nil?
      errors.add(:value, 'cannot be populated when error is populated')
      errors.add(:error, 'cannot be populated when value is populated')
    end
  end
end
