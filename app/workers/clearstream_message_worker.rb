class ClearstreamMessageWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(clearstream_vo)
    Clearstream.send_msg(clearstream_data: clearstream_vo)
  end
end
