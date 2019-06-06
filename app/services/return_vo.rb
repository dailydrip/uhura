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
    # rubocop:disable Style/DoubleNegation
    !!@error
    # rubocop:enable Style/DoubleNegation
  end

  def status
    # If there is a status, then return that else :unprocessable_entity
    @value[:status] || unprocessable_entity
  end

  def is_error?
    !self.error.nil?
  end

  def self.new_value(value_hash)
    self.new(value: return_accepted(value_hash), error: nil)
  end

  def self.new_err(err)
    self.new(value: nil, error: return_error(err, :unprocessable_entity))
  end

  private

  # rubocop:disable Metrics/AbcSize
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
  # rubocop:enable Metrics/AbcSize
end
