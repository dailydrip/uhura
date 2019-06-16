# frozen_string_literal: true

class SendSendgridMessageWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(sendgrid_vo)
    # sendgrid_vo = nil # <= create error
    SendgridHandler.send_msg(sendgrid_vo)
  end
end
