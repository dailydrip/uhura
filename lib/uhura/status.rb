# frozen_string_literal: true

# Status helpers are used on controllers and rspec
def return_success(data, status = 200)
  {
      status: status,
      data: data,
      error: nil
  }
end

def return_error(msg, status = 422)
  status = Rack::Utils::SYMBOL_TO_STATUS_CODE[status] if status.is_a? Symbol
  {
      status: status,
      data: nil,
      error: msg
  }
end

def return_server_error(msg, status = 500)
  status = Rack::Utils::SYMBOL_TO_STATUS_CODE[status] if status.is_a? Symbol
  {
      status: status,
      data: nil,
      error: msg
  }
end

def status_code(response_status_code)
  response_status_code if defined?(response_status_code) && !response_status_code.nil?
end
