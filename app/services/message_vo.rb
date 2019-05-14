# This is a value object that also performs data presence validation
class MessageVo

  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :manager_id,
                :manager_email,
                :manager_name,
                :team,  # X-TEAM-ID  HTTP header
                :receiver,
                :email_subject,
                :email_message,
                :template_id,
                :sms_message,
                :message_id

  def ActiveModel::initialize(*args)
    super
    validate!
  end

end
