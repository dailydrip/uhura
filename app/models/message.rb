class Message < ApplicationRecord
  belongs_to :sendgrid_msg, optional: true
  belongs_to :clearstream_msg, optional: true
  belongs_to :manager
  belongs_to :user
  belongs_to :team
  belongs_to :template

  alias_attribute :receiver, :user
  alias_attribute :receiver_id, :user_id
  alias_attribute :app, :manager
  alias_attribute :app_id, :manager_id
end
