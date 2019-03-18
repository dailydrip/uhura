# frozen_string_literal: true

def with_fake_server(example)
  real_api_endpoint = ENV['API_ENDPOINT']
  # Set the API endpoint to the fake server.
  ENV['API_ENDPOINT'] = "http://localhost:8080/#{ENV['API_VER']}"

  # Boolean to check whether the server has started.
  server_started = false

  # Start the fake server in a new thread, so we don't block execution.
  Thread.new do
    require "#{__dir__}/../../fake_api_server.rb"
    Rack::Handler::WEBrick.run(
      Cuba,
      Logger: WEBrick::Log.new(File.open(File::NULL, 'w')),
      AccessLog: [],
      StartCallback: -> { server_started = true }
    )
  end

  # Wait until we know the server is ready
  sleep(0.1) until server_started

  # Run our tests
  example.run

  # Switch the Config.api_endpoin back to what it was before.
  ENV['API_ENDPOINT'] = real_api_endpoint
end
