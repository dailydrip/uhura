# Error helpers are used on controllers and rspec
def return_error(msg)
  {
      'status': '422',
      'data': nil,
      'message': msg
  }
end

def return_server_error(msg)
  {
      'status': '500',
      'data': nil,
      'message': msg
  }
end

def return_success(data)
  {
      'status': '200',
      'data': data,
      'message': nil
  }
end