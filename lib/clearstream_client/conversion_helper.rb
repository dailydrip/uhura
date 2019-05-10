# frozen_string_literal: true

module ConversionHelper
  def methodize_attributes(*methods)
    h = {}
    methods.each { |m| h[m] = send(m) }
    h
  end
end
