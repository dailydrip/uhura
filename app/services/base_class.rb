# frozen_string_literal: true

class BaseClass
  def self.attr_accessor(*vars)
    @attributes ||= []
    @attributes.concat vars
    super(*vars)
  end

  class << self
    attr_reader :attributes
  end

  def attributes
    self.class.attributes
  end

  def my_attrs
    self.my_attributes = {} if my_attributes.nil?
    attributes.reject { |attr| attr == :validation_context }.each do |i|
      my_attributes[i] = send(i.to_s)
    end
    my_attributes.delete(:my_attributes)
    my_attributes
  end
end
