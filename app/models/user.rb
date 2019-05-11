class User < ApplicationRecord

  validate :valid_preferences?

  PHONE_REGEXP = /\A(?:\+?\d{1,3}\s*-?)?\(?(?:\d{3})?\)?[- ]?\d{3}[- ]?\d{4}\z/

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :mobile_number, format: { with: PHONE_REGEXP }

  def valid_preferences?
    # if self.preferences['email'] || self.preferences['sms']
      # errors.add(:preferences, 'User prefers both Email and SMS, but only one is required.')
    # end
    # if !self.preferences['email'] && !self.preferences['sms']
      # errors.add(:preferences, 'User prefers neither Email and SMS, but one is required.')
    # end
  end

  def opt_in_email
    self.preferences['email'] = true
    self.save!
  end
  def opt_out_email
    self.preferences['email'] = false
    self.save!
  end

  def opt_in_sms
    self.preferences['email'] = true
    self.save!
  end
  def opt_out_sms
    self.preferences['email'] = false
    self.save!
  end

  def preferred_channel
    return :email if preferences&.[]('email')
    return :sms if preferences&.[]('sms')
    return nil
  end

end
