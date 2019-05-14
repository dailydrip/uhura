
class HighlandsSSO
  def self.preferred_channel(receiver)

    #TODO Get preferred channel info from highlands sso
    return :email if receiver.preferences[:email]
    :sms

  end
end
