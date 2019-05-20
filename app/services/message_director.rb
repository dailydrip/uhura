# frozen_string_literal: true

# MessageDirector acts as a service, sending and email and/or an sms message

class MessageDirector
  def self.send(message_vo)
    ret = create_message(message_vo)
    if ret.error.nil?
      # Set message_id. Used to link SendgridMsg to Message later.
      message_vo.message_id = ret.value.id
    else
      # return error
      return ret
    end

    case ret.value.msg_target.name
    when 'Sendgrid'
      message = Sendgrid.send(message_vo)
      if message.error
        msg = message.error[:error]
        log_error(msg)
      else
        msg = "Sent Email: subject (#{message_vo.email_subject}) from (#{message_vo.manager_name}) to (#{message_vo.receiver_email})"
        log_info(msg)
      end
    when 'Clearstream'
      message = Clearstream.send(message_vo)
      if message.error
        msg = message.error[:error]
        log_error(msg)
      else
        msg = "Sent SMS: (#{message_vo.team_name}:#{message_vo.email_subject}) from (#{message_vo.manager_name}) to (#{message_vo.mobile_number})"
        log_info(msg)
      end
    else
      msg = "Sent message: subject (#{message_vo.sms_message}) to (#{message_vo.receiver_email}), but receiver prefers neither Email nor SMS!"
      log_error(msg)
      message = ReturnVo.new(value: nil, error: return_error(msg, :precondition_failed))
    end
    # Return message in a ReturnVo
    message
  end

  private

  # This is where we verify that the data passed matches with data in the database and set the message target.
  def self.create_message(message_vo)
    if !message_vo.valid?
      ReturnVo.new(value: nil, error: return_error(message_vo.errors, :unprocessable_entity))
    else
      ActiveRecord::Base.transaction do
        message = Message.create!(msg_target_id: message_vo.msg_target_id,
                                  manager_id: message_vo.manager_id, # <= source of message (an application)
                                  receiver_id: message_vo.receiver_id,
                                  team_id: message_vo.team_id, # <= message coming from this team
                                  email_subject: message_vo.email_subject,
                                  email_message: message_vo.email_message,
                                  template_id: message_vo.template_id,
                                  sms_message: message_vo.sms_message)

        ReturnVo.new(value: message, error: nil)
      rescue StandardError => e
        msg = "Exception (#{e.message}) occurred in create_message for #{message_vo.to_json}"
        log_error(msg)
        ReturnVo.new(value: nil, error: return_error(msg, :unprocessable_entity))
      end
    end
  end
end
