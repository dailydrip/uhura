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
      message = ReturnVo.new({value: nil, error: return_error(msg, :precondition_failed)})
    end
    # Return message in a ReturnVo
    message
  end

  private

  # This is where we verify that the data passed matches with data in the database and set the message target.
  def self.create_message(message_vo)
    errors = []
    manager_id = message_vo.manager_id   # A manager is the sending app.
    manager_email = message_vo.manager_email
    receiver = Receiver.find_by(receiver_sso_id: message_vo.receiver_sso_id)
    # Currently, we only support Sendgrid (for emails) and Clearstream (for sms)
    if receiver
      # Following message_vo attributes required by ClearstreamClient::MessageClient.create_subscriber
      message_vo.mobile_number = receiver.mobile_number
      message_vo.first = receiver.first_name
      message_vo.last = receiver.last_name
      message_vo.email = receiver.email
      message_vo.lists = AppCfg['CLEARSTREAM_DEFAULT_LIST_ID']
      if receiver.preferences
        delivery_target = receiver.preferences['email'] ? 'Sendgrid' : 'Clearstream'
        msg_target = MsgTarget.find_by(name: delivery_target)
        if msg_target
          msg_target_id = msg_target.id
        else
          errors <<  "Invalid receiver.preferences (#{receiver.preferences}). Unable to determine message target (Email/SMS)."
        end
      else
        errors << "Null receiver.preferences. Unable to determine message target (Email/SMS)."
      end
    end

    team = Team.find_by(name: message_vo.team_name)
    template = Template.find_by(template_id: message_vo.template_id)

    errors << "manager_id is nil"                                         if manager_id.nil?
    errors << "team (#{message_vo.team_name}) not found"                  if team.nil?
    errors << "receiver_sso_id (#{message_vo.receiver_sso_id}) not found" if receiver.nil?
    errors << "template_id (#{message_vo.template_id}) not found"         if template.nil?
    if errors.size > 0
      ReturnVo.new({value: nil, error: return_error(errors, :unprocessable_entity)})
    else
      ActiveRecord::Base.transaction do
        message = Message.create!(msg_target_id: msg_target_id,
                                  manager_id: manager_id, # <= source of message (an application)
                                  receiver_id: receiver.id,
                                  team_id: team.id, # <= message coming from this team
                                  email_subject: message_vo.email_subject,
                                  email_message: message_vo.email_message,
                                  template_id: template.id,
                                  sms_message: message_vo.sms_message)

        ReturnVo.new({value: message, error: nil})
      rescue => e
        msg = "Exception (#{e.message}) occurred in create_message for #{message_vo.to_json}"
        log_error(msg)
        ReturnVo.new({value: nil, error: return_error(msg, :unprocessable_entity)})
      end
    end
  end
end
