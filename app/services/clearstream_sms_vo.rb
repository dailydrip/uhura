class ClearstreamSmsVo
  Invalid = Class.new(StandardError)
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :receiver_email, :sms_message, :mobile_number, :first_name, :last_name, :lists, :message_header, :message_body, :subscribers, :schedule, :send_to_fb, :send_to_tw, :message_id
  validates :mobile_number, :message_header, :message_body, :subscribers, presence: true
  validates :schedule, :send_to_fb, :send_to_tw, inclusion: [true, false]

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

  def receiver_email=(receiver_email)
    @receiver_email = receiver_email
    # Find mobile_number for this receiver
    receiver = Receiver.find_by(email: receiver_email)
    if receiver
      # Following required by https://api.getclearstream.com/v1/messages
      @mobile_number = normalize_phone_number(receiver.mobile_number)
      @subscribers = @mobile_number
      @first_name = receiver.first_name
      @last_name = receiver.last_name
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
    {mobile_number: @mobile_number, first_name: @first_name, last_name: @last_name, receiver_email: @receiver_email, lists: @lists, message_header: @message_header, message_body: @message_body, subscribers: @subscribers, schedule: @schedule, send_to_fb: @send_to_fb, send_to_tw: @send_to_tw, message_id: @message_id}
  end
end
