# frozen_string_literal: true

class SendgridMessageJob < ApplicationJob
  queue_as :default

  def perform(sendgrid_vo)
    SendgridHandler.send_msg(sendgrid_vo)
  end
end
