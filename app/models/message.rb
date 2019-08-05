# frozen_string_literal: true

class Message < ApplicationRecord
  InvalidMessageError = Class.new(StandardError)
  include StatusHelper
  belongs_to :sendgrid_msg, optional: true
  belongs_to :clearstream_msg, optional: true
  belongs_to :manager
  belongs_to :receiver
  belongs_to :team
  belongs_to :template

  alias_attribute :app, :manager
  alias_attribute :app_id, :manager_id

  def self.message_and_status(id)
    message = Message.find(id)
    # If sendgrid_msg_status => nil then the receiver.preferences[:email] == false
    {
      message: message,
      status: {
        sendgrid_msg_status: message&.sendgrid_msg&.status,
        clearstream_msg_status: message&.clearstream_msg&.status
      }
    }
  end

  def sendgrid_status
    status[:sendgrid]
  end

  def clearstream_status
    status[:clearstream]
  end

  def status
    { sendgrid: sendgrid_msg&.status, clearstream: clearstream_msg&.status }
  end
end
