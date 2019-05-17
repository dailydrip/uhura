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

  def is_error?
    !!@error
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
