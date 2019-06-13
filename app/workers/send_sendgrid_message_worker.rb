class SendSendgridMessageWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(sendgrid_vo)
    Sendgrid.send_msg(sendgrid_data: sendgrid_vo)
  end
end
