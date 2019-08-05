# frozen_string_literal: true

module ErrorHandler
  def self.included(klass)
    klass.class_eval do
      rescue_from StandardError do |e|
        render_error_msg(e.to_s)
      end
    end
  end
end
