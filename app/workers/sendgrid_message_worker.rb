# frozen_string_literal: true

class SendgridMessageWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(sendgrid_vo)
    SendgridHandler.send_msg(sendgrid_vo)
  end
end
