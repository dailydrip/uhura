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
  validates :receiver_sso_id, numericality: { only_integer: true }
  validates :email_subject, presence: true
  validates :email_message, presence: true
  validates :template_id, presence: true
  # Required by ClearstreamClient::MessageClient.create_subscriber >>
  validates :mobile_number, format: { with: /\+?([\d|\(][\h|\(\d{3}\)|\.|\-|\d]{4,}\d)/,
                                      message: 'invalid mobile number' }
  validates :first, presence: true
  validates :last, presence: true
  validates :email, presence: true
  validates :lists, presence: true # <<
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
                :mobile_number, # Required by ClearstreamClient::MessageClient.create_subscriber >>
                :first,
                :last,
                :email,
                :lists, # <<
                :preferences,
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
    assign_attributes(message_params_vo.to_h.merge(manager_team_vo.to_h))

    ret = Receiver.from_user_preferences(
      highlands_data: {
        resource: 'user_preferences',
        id: @receiver_sso_id
      }
    )
    unless ret.error.nil?
      errors.add(:value, ret.error)
      return
    end
    receiver_attributes(ret.value[:data])
    team_attributes(team_name)
    template_attributes(template_id)
  end

  def receiver_attributes(receiver)
    # Receiver already exists
    self.receiver_id = receiver.id # Required by  Message.create!
    # Following message_vo attributes required by ClearstreamClient::MessageClient.create_subscriber
    self.mobile_number = receiver.mobile_number
    self.first = receiver.first_name
    self.last = receiver.last_name
    self.email = receiver.email
    self.lists = AppCfg['CLEARSTREAM_DEFAULT_LIST_ID']
    self.preferences = receiver.preferences
  end

  def team_attributes(team_name)
    team = Team.find_by(name: team_name)
    self.team_id = team.id if team
    self.team_name = team.name if team
  end

  def template_attributes(template_id)
    template = Template.find_by(template_id: template_id) # convert string template_id to template.id integer
    self.sendgrid_template_id = template_id
    self.template_id = template.id if template
  end

  def convert_preferences(preferences)
    self.email = preferences[0][:email] if preferences[0][:email].present?
    self.mobile_number = preferences[0][:phone_number] if preferences[0][:phone_number].present?
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
      preferences: convert_preferences(@preferences)
    }
  end

  # Return a hash that includes all instance variables, less the errors attribute.
  def to_h
    h = {}
    instance_variables.map do |name|
      # name[1..-1] strips the "@"  Example: {"@first": "Cindy"} => {"first": "Cindy"}
      h[name[1..-1]] = instance_variable_get(name) unless name.to_s.eql?('@errors')
    end
    h
  end
end
