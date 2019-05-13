# This is itended to be the service that
# communicates with Highlands SSO
class HighlandsSSO
  def self.preferred_channel(user)

    return :email if user.email.include?('smoothterminal')

    :sms
  end
end
