# frozen_string_literal: true

class InvalidMessage < ApplicationRecord
  belongs_to :sendgrid_msg, optional: true
  belongs_to :clearstream_msg, optional: true
  belongs_to :manager, optional: true
  belongs_to :receiver, optional: true
  belongs_to :team, optional: true
  belongs_to :template, optional: true

  alias_attribute :app, :manager
  alias_attribute :app_id, :manager_id

  def self.invalid_message_and_status(id)
    invalid_message = InvalidMessage.find(id)
    if "invalid_message&.target&.sendgrid?" #TODO <= determine using Message.sendgrid_msg_id
      sendgrid_msg_status = {
        errors: invalid_message.error_ary
      }
      clearstream_msg_status = nil
    elsif "invalid_message&.target&.clearstream?" #TODO <= determine using Message.clearstream_msg_id
      sendgrid_msg_status = nil
      clearstream_msg_status = nil # TODO: implement me
    else
      sendgrid_msg_status = nil
      clearstream_msg_status = nil
      log_error("Invalid target for invalid_message (#{invalid_message})")
    end
    {
      message: invalid_message,
      status: {
        sendgrid_msg_status: sendgrid_msg_status,
        clearstream_msg_status: clearstream_msg_status
      }
    }
  end

  # def target
  #   if msg_target.name.eql?('Sendgrid')
  #     sendgrid_msg
  #   elsif msg_target.name.eql?('Clearstream')
  #     clearstream_msg
  #   else
  #     log_err!("Invalid msg_target #{msg_target} for message #{id}")
  #   end
  # end

  def error_ary
    message_attrs['errors']['value']
  end
end
