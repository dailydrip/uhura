
class HighlandsSSO
  def self.preferred_channel(user)

    #TODO Get preferred channel info from highlands sso
    return :email if ENV['UHU_PREF_CHANNEL']&.upcase =='EMAIL'
    :sms

  end
end
