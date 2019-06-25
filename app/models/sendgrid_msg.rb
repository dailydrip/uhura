# frozen_string_literal: true

class SendgridMsg < ApplicationRecord
  def message
    Message.find_by(sendgrid_msg_id: id)
  end

  def status
    if sendgrid_response.eql?('202') && attributes['status'].nil?
      'accepted_by_sendgrid'
    else
      attributes['status']
    end
  end
end
