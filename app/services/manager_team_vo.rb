# frozen_string_literal: true

# This is a value object that also performs data presence validation
class ManagerTeamVo < BaseClass
  InvalidManagerTeam = Class.new(StandardError)

  include ActiveModel::Model
  include ActiveModel::Validations

  validates :manager_id, presence: true
  validates :manager_name, presence: true
  validates :manager_email, presence: true
  validates :team_name, presence: true

  attr_accessor :manager_id,
                :manager_name,
                :manager_email,
                :team_name,
                :my_attributes

  def initialize(*args)
    super(args[0])
    raise InvalidManagerTeam, 'invalid manager_team_vo' unless valid?
  end
end
