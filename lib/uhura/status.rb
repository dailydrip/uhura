# frozen_string_literal: true

# Status helpers are used on controllers and rspec
def return_success(data, status = 200)
  status = Rack::Utils::SYMBOL_TO_STATUS_CODE[status] if status.is_a? Symbol
  {
    status: status,
    data: data,
    error: nil
  }
end

def return_accepted(data, status = 202)
  status = Rack::Utils::SYMBOL_TO_STATUS_CODE[status] if status.is_a? Symbol
  {
    status: status,
    data: data,
    error: nil
  }
end

# Example:
# . . .
# rescue StandardError => e
#   msg = "Sendgrid.send Error: #{e.message}"
#   log_error(msg)
#   ReturnVo.new(value: nil, error: return_error(msg, :unprocessable_entity))
# end
def return_error(msg, status = 422)
  status = Rack::Utils::SYMBOL_TO_STATUS_CODE[status] if status.is_a? Symbol
  {
    status: status,
    data: nil,
    error: msg
  }
end
