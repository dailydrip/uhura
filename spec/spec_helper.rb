# frozen_string_literal: true

require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)
FIXTURE_DIR = "#{__dir__}/support/fixtures"
require 'helpers'

RSpec.configure do |config|
  config.include Helpers

  # Capture requests bound for external API's and redirect to fake servers:
  config.before(:each) do
    # An HTTP client
    # stub_request(:any, /api.getclearstream.com/).to_rack(FakeClearstream)
    # A Ruby (HTTP adapter) client
    # stub_request(:any, /#{ENV['API_ENDPOINT']}/).to_rack(FakeSendgrid)
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end

# Print and save the PID of the currently running rspec process:
puts "rspec pid: #{Process.pid}"
# Use in conjunction with:  alias kill-rspec-pid='kill -USR1 "$(cat /tmp/rspec.pid)"'
`printf #{Process.pid} > /tmp/rspec.pid`

# Trap -USR1 event and print stack trace.
#  get the stacktraces for all threads and it doesn't halt the process.
# So, you can run it repeatedly to see if it's staying stuck at one spot,
# or if it's making progress but just going really slow or whatever.
trap 'USR1' do
  threads = Thread.list
  puts
  puts '-' * 80
  puts "Received USR1 signal; printing all #{threads.count} thread backtraces."
  threads.each do |thr|
    description = thr == Thread.main ? 'Main thread' : thr.inspect
    puts
    puts "#{description} backtrace: "
    puts thr.backtrace.join("\n")
  end
  puts '-' * 80
end