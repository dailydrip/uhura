class ClearstreamMessageWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(clearstream_vo)

    # response = Clearstream.send(message_vo)
    # if response.error
    #   msg = response.error[:error]
    #   log_error(msg)
    # else
    #   msg = "Sent SMS: (#{message_vo.team_name}:#{message_vo.email_subject}) "
    #   msg += "from (#{message_vo.manager_name}) to (#{message_vo.mobile_number})"
    #   log_info(msg)
    # end

    Clearstream.send_msg(clearstream_data: clearstream_vo)

    log! ">> SIDEKIQ ClearstreamMessageWorker processing message #{clearstream_vo}"
  end
end
