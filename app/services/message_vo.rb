# frozen_string_literal: true

# This is a value object that also performs data presence validation
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
                :template_id, # ID to templates table
                :sendgrid_template_id,
                :sms_message,
                :message_id,
                :msg_target_id,
                :mobile_number, # Required by ClearstreamClient::MessageClient.create_subscriber >>
                :first,
                :last,
                :email,
                :lists # <<

  # rubocop:disable all
  def initialize(message_params_vo, manager_team_vo)
    raise InvalidMessageError, 'invalid message_params_vo' unless message_params_vo.valid?
    raise InvalidManagerTeamError, 'invalid manager_team_vo' unless manager_team_vo.valid?

    # Valid input. Now, perform lookups to fill in missing data prior to processing request.
    assign_attributes(message_params_vo.my_attrs.merge(manager_team_vo.my_attrs))

    receiver = Receiver.find_or_enroll(receiver_sso_id)
    if receiver
      self.receiver_id = receiver.id # Required by  Message.create!
      # Following message_vo attributes required by ClearstreamClient::MessageClient.create_subscriber
      self.mobile_number = receiver.mobile_number
      self.first = receiver.first_name
      self.last = receiver.last_name
      self.email = receiver.email
      self.lists = AppCfg['CLEARSTREAM_DEFAULT_LIST_ID']
      @receiver_preferences = receiver.preferences
      msg_target = MsgTarget.find_by(name: receiver.preferences['email'] ? 'Sendgrid' : 'Clearstream')
      self.msg_target_id = msg_target.id  if msg_target
    end
    team = Team.find_by(name: team_name)
    self.team_id = team.id if team
    self.team_name = team.name if team
    template = Template.find_by(template_id: template_id) # convert string template_id to template.id integer
    self.sendgrid_template_id = self.template_id
    self.template_id = template.id if template
  end

  def receiver_preferences
    if msg_target_id.nil?
      msg = "Invalid receiver.preferences (#{@receiver_preferences}). Unable to determine message target (Email/SMS)."
      log_error(msg)
      errors.add(:value, msg)
    end
  end
end
