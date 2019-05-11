class ClearstreamSmsVo
  Invalid = Class.new(StandardError)
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :receiver_email, :sms_message, :mobile_number, :message_header, :message_body, :lists, :schedule, :send_to_fb, :send_to_tw
  validates :mobile_number, :message_header, :message_body, :lists, presence: true
  validates :schedule, :send_to_fb, :send_to_tw, inclusion: [true, false]

  def initialize(*args)
    super
    # Following required by https://api.getclearstream.com/v1/messages
    self.lists ||= AppCfg['CLEARSTREAM_DEFAULT_LIST_ID']
    self.schedule ||= false
    self.send_to_fb ||= false
    self.send_to_tw ||= false
  end

  def receiver_email=(receiver_email)
    @receiver_email = receiver_email
    # Find mobile_number for this receiver
    receiver = User.find_by(email: receiver_email)
    if receiver
      # Following required by https://api.getclearstream.com/v1/messages
      @mobile_number = receiver.mobile_number
    end
  end
  def receiver_email
    @receiver_email
  end

  # "sms_message": {
  #     "header": "Blue Sushi 2",
  #     "body": "Come in now for 60% off all rolls!"
  # }
  def sms_message=(sms_message)
    @sms_message = sms_message
    # Following required by https://api.getclearstream.com/v1/messages
    @message_header = sms_message['header']
    @message_body = sms_message['body']
  end
  def sms_message
    sms_message
  end

  def get
    if !valid?
      raise Invalid, errors.full_messages
    end
    {mobile_number: @mobile_number, message_header: @message_header, message_body: @message_body, lists: @lists, schedule: @schedule, send_to_fb: @send_to_fb, send_to_tw: @send_to_tw}
  end
end
