# frozen_string_literal: true

class Team < ApplicationRecord
  def self.error_message_for_team(x_team_id)
    err_msg = "Team ID (#{x_team_id}) from the X-Team-ID HTTP header NOT found! "
    err_msg += "Consider adding Team for ID (#{x_team_id}) using the Admin app on the Teams page."
    err_msg
  end
end
