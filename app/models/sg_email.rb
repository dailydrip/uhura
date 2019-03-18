class SgEmail < ApplicationRecord

  validates :from_email, presence: true
  validates :to_email, presence: true
  validates :subject, presence: true
  validates :content, presence: true
  validates_format_of :from_email, :with => /@/
  validates_format_of :to_email, :with => /@/

  validate :from_and_to_emails_must_be_different

  def response_is_valid?
    self.valid! && self.response_status_code == '202'
  end

  private

  def from_and_to_emails_must_be_different
    if from_email == to_email
      errors.add(:to_email, 'should be different than from_email')
    end
  end

end
