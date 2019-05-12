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
    #stub_request(:any, /api.getclearstream.com/).to_rack(FakeClearstream)
    # A Ruby (HTTP adapter) client
    #stub_request(:any, /#{ENV['API_ENDPOINT']}/).to_rack(FakeSendgrid)
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
