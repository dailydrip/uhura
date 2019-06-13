# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :msg_target
  belongs_to :sendgrid_msg, optional: true
  belongs_to :clearstream_msg, optional: true
  belongs_to :manager
  belongs_to :receiver
  belongs_to :team
  belongs_to :template

  alias_attribute :app, :manager
  alias_attribute :app_id, :manager_id

  def target
    if self.msg_target.name.eql?('Sendgrid')
      self.sendgrid_msg
    elsif self.msg_target.name.eql?('Clearstream')
      self.clearstream_msg
    else
      log_err!("Invalid msg_target #{self.msg_target} for message #{self.id}")
    end
  end

  def target_name
    if self.target.nil?
      msg_target = MsgTarget.find(self.msg_target_id)
      if msg_target.nil?
        log_err!("Invalid msg_target #{self.msg_target}")
      else
        msg_target.name
      end
    else
      msg_target.name
    end
  end
end
