# frozen_string_literal: true

class ClearstreamMessageJob < ApplicationJob
  queue_as :default

  def perform(clearstream_vo)
    ClearstreamHandler.send_msg(clearstream_vo: clearstream_vo)
  end
end
