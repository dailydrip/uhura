# This is a value object that also performs data presence validation
class MessageVo

  include ActiveModel::Model
  include ActiveModel::Validations

  validates :manager_id, numericality: {greater_than: 0}
  validates :manager_email, presence: true
  validates :manager_name, presence: true
  validates :team_name, presence: true
  validates :receiver_sso_id, format: {with: /\A\d+\z/, message: "integers only"}
  validates :email_subject, presence: true
  validates :email_message, presence: true
  validates :template_id, presence: true
  validates :teamsms_message_name, presence: true
  validates :mobile_number, presence: true  # This and following needed by ClearstreamClient::MessageClient.create_subscriber
  validates :first, presence: true
  validates :last, presence: true
  validates :email, presence: true
  validates :lists, presence: true

  attr_accessor :manager_id,
                :manager_email,
                :manager_name,
                :team_name,  # X-TEAM-ID  HTTP header
                :receiver_sso_id,
                :receiver_email, # Populated when receiver_sso_id is assigned a value
                :email_subject,
                :email_message,
                :template_id,
                :sms_message,
                :message_id,
                :mobile_number, # This and following needed by ClearstreamClient::MessageClient.create_subscriber
                :first,
                :last,
                :email,
                :lists

  def ActiveModel::initialize(*args)
    super
    validate!
  end

end
