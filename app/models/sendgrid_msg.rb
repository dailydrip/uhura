# frozen_string_literal: true

class SendgridMsg < ApplicationRecord
  def message
    Message.find_by(sendgrid_msg_id: id)
  end
end
