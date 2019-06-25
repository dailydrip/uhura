# frozen_string_literal: true

class Message < ApplicationRecord
  InvalidMessageError = Class.new(StandardError)
  include StatusHelper
  belongs_to :msg_target
  belongs_to :sendgrid_msg, optional: true
  belongs_to :clearstream_msg, optional: true
  belongs_to :manager
  belongs_to :receiver
  belongs_to :team
  belongs_to :template

  alias_attribute :app, :manager
  alias_attribute :app_id, :manager_id

  def target
    if msg_target.name.eql?('Sendgrid')
      sendgrid_msg
    elsif msg_target.name.eql?('Clearstream')
      clearstream_msg
    else
      log_err!("Invalid msg_target #{msg_target} for message #{id}")
    end
  end

  def self.message_and_status(id)
    message = Message.find(id)
    {
      message: message,
      status: {
        sendgrid_msg_status: message&.sendgrid_msg&.status ||
          check_for_missing_status(message)[:sendgrid_error_msg],
        clearstream_msg_status: message&.clearstream_msg&.status ||
          check_for_missing_status(message)[:clearstream_error_msg]
      }
    }
  end

  def self.check_for_missing_status(message)
    if message&.msg_target&.sendgrid?
      sendgrid_error_msg = 'message_has_been_queued' if message&.sendgrid_msg.nil?
    elsif message&.msg_target&.clearstream?
      clearstream_error_msg = 'message_has_been_queued' if message&.clearstream_msg.nil?
    else
      raise InvalidMessageError, 'invalid_message__missing_target'
    end
    { sendgrid_error_msg: sendgrid_error_msg, clearstream_error_msg: clearstream_error_msg }
  end

  def target_name
    if target.nil?
      msg_target = MsgTarget.find(msg_target_id)
      if msg_target.nil?
        log_err!("Invalid msg_target #{msg_target}")
      else
        msg_target.name
      end
    else
      msg_target.name
    end
  end
end
