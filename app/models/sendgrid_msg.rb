# frozen_string_literal: true

class SendgridMsg < ApplicationRecord
  def message
    Message.find_by(sendgrid_msg_id: id)
  end

  def status
    if self.sendgrid_response.eql?('202') && self.attributes['status'].nil?
      'accepted_by_sendgrid'
    end
  end
end
