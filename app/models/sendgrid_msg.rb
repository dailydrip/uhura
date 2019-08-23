# frozen_string_literal: true

class SendgridMsg < ApplicationRecord
  has_many :sendgrid_msg_events, dependent: :restrict_with_exception

  def message
    Message.find_by(sendgrid_msg_id: id)
  end

  def status
    return attributes['status'] if attributes['status'].present?

    if sendgrid_response.eql?('202')
      # We can fabricate this status based on the fact that sendgrid accepted the request
      'accepted'
    else
      # Return the actual status_code from sendgrid if status is nil and response was not accepted (202)
      mail_and_response = attributes['mail_and_response']
      mail_and_response['response']['status_code'] if mail_and_response && mail_and_response['response']
    end
  end
end
