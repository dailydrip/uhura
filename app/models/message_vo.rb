# frozen_string_literal: true

class MessageVo
  InvalidMessageError = Class.new(StandardError)
  InvalidManagerTeamError = Class.new(StandardError)

  include ActiveModel::Model
  include ActiveModel::Validations

  validates :manager_id, numericality: { greater_than: 0 }
  validates :manager_email, presence: true
  validates :manager_name, presence: true
  validates :team_name, presence: true
  validates :receiver_sso_id, format: { with: /\A\d+\z/, message: 'integers only' }
  validates :email_subject, presence: true
  validates :email_message, presence: true
  validates :template_id, presence: true
  validates :mobile_number, presence: true # Required by ClearstreamClient::MessageClient.create_subscriber >>
  validates :first, presence: true
  validates :last, presence: true
  validates :email, presence: true
  validates :lists, presence: true # <<
  validate :receiver_preferences
  validate :template_found

  attr_accessor :public_token,
                :manager_id,
                :manager_email,
                :manager_name,
                :team_id, # Required by Message.create!
                :team_name,
                :receiver_sso_id,
                :receiver_id, # Required by Message.create!
                :receiver_email, # Populated when receiver_sso_id is assigned a value
                :email_subject,
                :email_message,
                :email_options,
                :template_id, # ID to templates table
                :sendgrid_template_id,
                :sms_message,
                :message_id,
                :msg_target_id,
                :mobile_number, # Required by ClearstreamClient::MessageClient.create_subscriber >>
                :first,
                :last,
                :email,
                :lists, # <<
                :errors

  alias_attribute :first_name, :first
  alias_attribute :last_name, :last

  def initialize(message_params_vo, manager_team_vo)
    raise InvalidMessageError, 'invalid message_params_vo' unless message_params_vo.valid?
    raise InvalidManagerTeamError, 'invalid manager_team_vo' unless manager_team_vo.valid?

    @errors = ActiveModel::Errors.new(self)
    init_attributes(message_params_vo, manager_team_vo)
  end

  def init_attributes(message_params_vo, manager_team_vo)
    # Valid input. Now, perform lookups to fill in missing data prior to processing request.
    assign_attributes(message_params_vo.my_attrs.merge(manager_team_vo.my_attrs))

    # receiver = Receiver.find_by(receiver_sso_id: @receiver_sso_id)
    # Call https://sso.highlandsapp.com/api/v1/user_preferences?id=63501603&token=346aba8a-da63-464d-b4b2-2bdcdc3a31b1

    ret = get_receiver({
                           highlands_data: {
                               resource: 'user_preferences',
                               id: @receiver_sso_id,
                           }
                       })
    if !ret.error.nil?
      errors.add(:value, ret.error)
      return
    end

    handle_when_receiver(ret.value[:data])

    team = Team.find_by(name: team_name)
    self.team_id = team.id if team
    self.team_name = team.name if team
    template = Template.find_by(template_id: template_id) # convert string template_id to template.id integer
    self.sendgrid_template_id = template_id
    self.template_id = template.id if template
  end

  def handle_when_receiver(receiver)
    # Receiver already exists
    self.receiver_id = receiver.id # Required by  Message.create!
    # Following message_vo attributes required by ClearstreamClient::MessageClient.create_subscriber
    self.mobile_number = receiver.mobile_number
    self.first = receiver.first_name
    self.last = receiver.last_name
    self.email = receiver.email
    self.lists = AppCfg['CLEARSTREAM_DEFAULT_LIST_ID']
    handle_msg_target(receiver)
  end

  def convert_preferences(preferences)
    {
        email: !preferences[0][:email].blank?,
        sms: !preferences[0][:phone_number].blank?
    }
    if !preferences[0][:email].blank?
      self.email = preferences[0][:email]
    end
    if !preferences[0][:phone_number].blank?
      self.mobile_number = preferences[0][:phone_number]
    end
  end

  def handle_msg_target(receiver)
    @receiver_preferences = convert_preferences(receiver.preferences)
    msg_target = MsgTarget.find_by(name: receiver.preferences['email'] ? 'Sendgrid' : 'Clearstream')
    self.msg_target_id = msg_target.id if msg_target
  end

  def receiver_preferences
    if msg_target_id.nil?
      msg = "Invalid receiver.preferences (#{@receiver_preferences}). Unable to determine message target (Email/SMS)."
      log_error(msg)
      errors.add(:value, msg)
    end
  end

  def template_found
    sendgrid_template = Template.find_by(id: template_id)
    if sendgrid_template.nil?
      msg = "Template ID (#{template_id}) not found. If it is valid, add it via the Admin application."
      log_error(msg)
      errors.add(:value, msg)
    end
  end

  def invalid_message_attrs
    {
      msg_target_id: @msg_target_id,
      manager_id: @manager_id,
      receiver_id: @receiver_id,
      team_id: @team_id,
      email_subject: @email_subject,
      email_message: @email_message,
      email_options: @email_options,
      template_id: @template_id,
      sms_message: @sms_message
    }
  end

  def user_attributes
    {
        receiver_sso_id: @receiver_sso_id,
        email: @email,
        mobile_number: @mobile_number,
        first_name: @first_name,
        last_name: @last_name,
        preferences: self.convert_preferences(@preferences)
    }
  end

  def to_hash
    Hash[instance_variables.map do |name|
      # Strip "@"  Example: {"@first": "Cindy"} => {"first": "Cindy"}
      [name[1..-1], instance_variable_get(name)] unless name.eql?('@errors')
    end ]
  end

  private

  def get_receiver(data)
    data = data[:highlands_data]
    response = HighlandsClient::MessageClient.new(data: data,
                                                  resource: data[:resource]).get_receiver(data[:id])
    if response.nil?
      return ReturnVo.new(value: nil, error: return_error('get_user_preferences not found', :unprocessable_entity))
    else
      user = response
      user['preferences'] = convert_preferences(response['preferences'])
      user['mobile_number'] = response['phone_number']
      user.delete('phone_number')
      user['receiver_sso_id'] = response['user_id']
      user.delete('user_id')
      receiver = Receiver.new(user)
      return ReturnVo.new(value: nil, error: return_error('Invalid user', :unprocessable_entity)) unless receiver.valid?

      existing_receiver = Receiver.find_by(receiver_sso_id: receiver.receiver_sso_id)
      if existing_receiver
        if !existing_receiver.user_attributes.eql?(receiver.user_attributes)
          existing_receiver = Receiver.update!(receiver.user_attributes)
          log_warn("Old receiver attributes (#{existing_receiver.user_attributes}) => New attributes (#{receiver.user_attributes})")
        end
        receiver = existing_receiver # Gets the id attribute
      else
        # Create new user record
        receiver.save!
      end
      return ReturnVo.new(value: return_accepted(receiver), error: nil)
    end
  end

  # FROM
  #     "preferences": [
  #       {
  #         "email": "user.name@example.com",
  #         "phone_number": "999-999-9999"
  #       }
  #     ]
  # TO  {email: false, sms: false}
  def convert_preferences(preferences)
    if preferences[0].blank?
      return {email: false, sms: false}
    else
      {
          email: !preferences[0][:email].blank?,
          sms: !preferences[0][:phone_number].blank?
      }
    end
  end
end
