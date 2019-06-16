# frozen_string_literal: true

class ClearstreamMessageWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(clearstream_vo)
    ClearstreamHandler.send_msg(clearstream_vo: clearstream_vo)
  end
end
