module ClearstreamAble
  extend ActiveSupport::Concern

  included do
    after_create -> { sms }
  end

  def sms
    UserMailer.weekly_summary(self).deliver_now
  end
end