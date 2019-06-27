# frozen_string_literal: true

class MsgTarget < ApplicationRecord
  def sendgrid?
    name.eql?('Sendgrid')
  end

  def clearstream?
    name.eql?('Clearstream')
  end
end
