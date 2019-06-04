# frozen_string_literal: true

module ClearstreamClient
  class MessageClient < BaseClient
    alias send_message create
  end
end
