# frozen_string_literal: true

class MsgTarget < ApplicationRecord
  def is_sendgrid?
    self.name.eql?('Sendgrid')
  end

  def is_clearstream?
    self.name.eql?('Clearstream')
  end
end
