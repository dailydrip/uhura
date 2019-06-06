# frozen_string_literal: true

class InvalidMessage < ApplicationRecord
  belongs_to :msg_target, optional: true
  belongs_to :sendgrid_msg, optional: true
  belongs_to :clearstream_msg, optional: true
  belongs_to :manager, optional: true
  belongs_to :receiver, optional: true
  belongs_to :team, optional: true
  belongs_to :template, optional: true

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
end
