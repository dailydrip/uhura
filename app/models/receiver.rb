# frozen_string_literal: true

class Receiver < ApplicationRecord
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :receiver_sso_id, numericality: { only_integer: true }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :mobile_number, presence: true
  validates :preferences, presence: true

  def to_name
    "#{first_name} #{last_name}".strip
  end

  def self.from_user_preferences(data)
    data = data[:highlands_data]
    response = HighlandsClient::MessageClient.new(data: data,
                                                  resource: data[:resource]).get_receiver(data[:id])
    if response.nil?
      return ReturnVo.new(value: nil, error: return_error('get_user_preferences not found', :unprocessable_entity))
    elsif response[:error] && response[:error][:message]
      return ReturnVo.new(value: nil, error: return_error(JSON.parse(response[:error][:message])['error'],
                                                          :unprocessable_entity))
    else
      return receiver_vo(receiver_from_response(response))
    end
  end

  def user_attributes
    attributes.except('id', 'created_at', 'updated_at')
  end

  def self.receiver_from_response(response)
    user = response
    user_preferences = convert_receiver_preferences(response['preferences'])
    # Store only numeric characters in mobile_number
    user['mobile_number'] = response['phone_number'].tr('^0-9', '')
    user.delete('phone_number')
    user['email'] = response['preferences'][0]['email'] if user_preferences[:email]
    user['preferences'] = user_preferences
    user['receiver_sso_id'] = response['user_id']
    user.delete('user_id')
    receiver = Receiver.new(user)
    receiver
  end

  # FROM
  #     "preferences": [
  #       {
  #         "email": "user.name@example.com",
  #         "phone_number": "999-999-9999"
  #       }
  #     ]
  # TO  {email: false, sms: false}
  def self.convert_receiver_preferences(preferences)
    if preferences[0].blank?
      log_warn("Empty preferences, i.e., no message target, for receiver_sso_id (#{receiver_sso_id})")
      {
        email: false,
        sms: false
      }
    else
      {
        email: preferences[0]['email'].present?,
        sms: preferences[0]['phone_number'].present?
      }
    end
  end

  def self.find_or_enroll(receiver_sso_id)
    existing_receiver = Receiver.find_by(receiver_sso_id: receiver_sso_id)
    if existing_receiver
      unless existing_receiver.user_attributes.eql?(receiver.user_attributes)
        existing_receiver.attributes = receiver.user_attributes
        existing_receiver.save!
        msg = "Old receiver attributes (#{existing_receiver.user_attributes})"
        msg += " => New attributes (#{receiver.user_attributes})"
        log_warn(msg)
      end
      receiver = existing_receiver # Gets the id attribute
    else
      # Create new user record
      receiver.save!
    end
    receiver
  end

  def self.receiver_vo(receiver)
    unless receiver.valid?
      return ReturnVo.new(value: nil, error: return_error("Invalid user (#{receiver.user_attributes})",
                                                          :unprocessable_entity))
    end

    receiver = find_or_enroll(receiver.receiver_sso_id)
    ReturnVo.new(value: return_accepted(receiver), error: nil)
  end
end
