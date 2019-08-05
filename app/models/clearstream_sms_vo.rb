# frozen_string_literal: true

class ClearstreamSmsVo
  Invalid = Class.new(StandardError)
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :receiver_email,
                :mobile_number,
                :first_name,
                :last_name,
                :lists,
                :message_header,
                :message_body,
                :team_name,
                :subscribers,
                :schedule,
                :send_to_fb,
                :send_to_tw,
                :message_id

  validates :mobile_number,
            :message_header,
            :message_body,
            :team_name,
            :subscribers, presence: true

  validates :schedule,
            :send_to_fb,
            :send_to_tw, inclusion: [true, false]

  def initialize(*args)
    super
    # Following required by https://api.getclearstream.com/v1/messages
    self.lists ||= AppCfg['CLEARSTREAM_DEFAULT_LIST_ID']
    self.schedule ||= false
    self.send_to_fb ||= false
    self.send_to_tw ||= false
  end

  # Clearstream will store 10 digit number, but requires "+1" for subsequent calls
  def normalize_phone_number(number)
    return number if number[0..1].eql?('+1')

    '+1' + number
  end

  # The receiver is the Highlands SSO ID
  def receiver_sso_id=(receiver_sso_id)
    # Find mobile_number for this receiver
    receiver = Receiver.find_by(receiver_sso_id: receiver_sso_id)
    if receiver
      @receiver_email = receiver.email
      # Following required by https://api.getclearstream.com/v1/messages
      @mobile_number = normalize_phone_number(receiver.mobile_number)
      @subscribers = @mobile_number
      @first_name = receiver.first_name
      @last_name = receiver.last_name
    end
  end

  attr_reader :receiver_sso_id

  def sms_message=(sms_message)
    @sms_message = sms_message
    # Following required by https://api.getclearstream.com/v1/messages
    @message_header = @team_name
    @message_body = sms_message
  end

  def sms_message
    sms_message
  end

  def vo
    raise Invalid, errors.full_messages unless valid?

    {
      resource: 'messages',
      message_id: @message_id,
      mobile_number: @mobile_number,
      message_header: @message_header,
      message_body: @message_body,
      subscribers: @subscribers,
      schedule: @schedule,
      send_to_fb: @send_to_fb,
      send_to_tw: @send_to_tw 
    }
  end

  def sent_for_processing_msg
    msg = "Sent SMS: (#{@team_name}:#{@email_subject}) "
    msg += "from (#{@manager_name}) to (#{@mobile_number})"
    msg += 'for processing.'
    msg
  end
end
