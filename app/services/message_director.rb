# MessageDirector acts as a service, sending and email and/or an sms message

class MessageDirector

  def self.send(message_vo)
    ActiveRecord::Base.transaction do

      message = create_message(message_vo)
      if message.error.nil?
        # Set message_id. Used to link SendgridMsg to Message later.
        message_vo.message_id = message.value.id
      else
        # return error
        return message
      end

      receiver = message.value.user
      case receiver.preferred_channel
      when :email
        message = Sendgrid.send(message_vo)
        if message.error
          msg = message.error[:error]
          log_error(msg)
        else
          msg = "Sent Email: subject (#{message_vo.email_subject}) from (#{message_vo.manager_name}) to (#{message_vo.receiver_email})"
          log_info(msg)
        end
      when :sms
        message = Clearstream.send(message_vo)
        if message.error
          msg = message.error[:error]
          log_error(msg)
        else
          msg = "Sent SMS: subject (#{message_vo.email_subject}) from (#{message_vo.manager_name}) to (#{message_vo.receiver_email})"
          log_info(msg)
        end
      else
        msg = "Sent message: subject (#{message_vo.sms_message}) to (#{message_vo.receiver_email}), but receiver prefers neither Email nor SMS!"
        log_error(msg)
        message = ReturnVo.new({value: nil, error: return_error(msg, :precondition_failed)})
      end

      message

    rescue => e
      msg = "Exception (#{e.message}) occurred in create_message for #{message_vo.to_json}"
      log_error(msg)
      ReturnVo.new({value: nil, error: error_json = return_error(msg, :unprocessable_entity)})
    end
  end

  private

  def self.create_message(message_vo)
    manager_id = message_vo.manager_id   # A manager is the sending app.
    manager_email = message_vo.manager_email
    receiver = User.find_by(email: message_vo.receiver_email)
    team = Team.find_by(name: message_vo.team_name)
    template = Template.find_by(template_id: message_vo.template_id)
    errs = []
    errs << "manager_id is nil"                                       if manager_id.nil?
    errs << "team_name (#{message_vo.team_name}) not found"           if team.nil?
    errs << "receiver_email (#{message_vo.receiver_email}) not found" if receiver.nil?
    errs << "template_id (#{message_vo.template_id}) not found"       if template.nil?
    if errs.size > 0
      ReturnVo.new({value: nil, error: error_json = return_error(errs, :unprocessable_entity)})
    else
      message = Message.create!(manager_id: manager_id, # <= source of message (an application)
                                user_id: receiver.id,
                                team_id: team.id, # <= message coming from this team
                                email_subject: message_vo.email_subject,
                                email_message: message_vo.email_message,
                                template_id: template.id,
                                sms_message: message_vo.sms_message)

      ReturnVo.new({value: message, error: nil})
    end
  end
end
