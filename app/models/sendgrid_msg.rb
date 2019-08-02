# frozen_string_literal: true

class SendgridMsg < ApplicationRecord
  has_many :sendgrid_msg_events

  def message
    Message.find_by(sendgrid_msg_id: id)
  end

  def status
    if sendgrid_response.eql?('202') && attributes['status'].nil?
      'accepted_by_sendgrid'
    elsif sendgrid_response.nil? && attributes['status'].nil?
      mail_and_response = JSON.parse(attributes['mail_and_response'])
      if mail_and_response && mail_and_response['response']
        mail_and_response['response']['status_code']
      end
    else
      attributes['status']
    end
  end
end
