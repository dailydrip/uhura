# frozen_string_literal: true

class SendgridMsg < ApplicationRecord
  has_many :sendgrid_msg_events, dependent: :restrict_with_exception

  def message
    Message.find_by(sendgrid_msg_id: id)
  end

  def status
    if attributes['status'].nil?
      if sendgrid_response.eql?('202')
        # We can fabricate this status based on the fact that sendgrid accepted the request
        'accepted_by_sendgrid'
      else
        # Return the actual status_code from sendgrid if status is nil and response was not accpeted (202)
        mail_and_response = JSON.parse(attributes['mail_and_response'])
        mail_and_response['response']['status_code'] if mail_and_response && mail_and_response['response']
      end
    else
      attributes['status']
    end
  end
end
