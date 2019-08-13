# frozen_string_literal: true

class BaseClass
  attr_accessor :my_attributes

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

  # Return a hash that includes all instance variables, less the errors and validation_context attributes.
  def to_h
    h = {}
    instance_variables.map do |name|
      unless name.to_s.eql?('@errors') || name.to_s.eql?('@validation_context')
        h[name[1..-1]] = instance_variable_get(name)
      end
    end
    h
  end
end
