# frozen_string_literal: true

# Error helpers are used on controllers and rspec
def return_error(msg, status=500)
  {
    status: status,  # return 422 for unprocessable or 500 for server error
    data: nil,
    error: msg
  }
end

def return_success(data, status=200)
  {
    status: status,
    data: data,
    error: nil
  }
end

def status_code(response_status_code)
  if defined?(response_status_code) && !response_status_code.nil?
    response_status_code
  else
    nil
  end
end