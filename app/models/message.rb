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

  def target_names
    target_names = []
    preferences = Receiver.find_by(id: self.receiver_id).preferences
    target_names << EMAIL_KEY if preferences[EMAIL_KEY]
    target_names << SMS_KEY if preferences[SMS_KEY]
  end

  def sendgrid_status
    self.status[:sendgrid]
  end

  def clearstream_status
    self.status[:clearstream]
  end

  def status
    { sendgrid: self.sendgrid_msg&.status, clearstream: self.clearstream_msg&.status }
  end

end
