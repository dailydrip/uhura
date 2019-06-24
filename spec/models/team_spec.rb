# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Team, type: :model do
  describe 'fields' do
    it { is_expected.to respond_to(:name) }
  end

  describe '.error_message_for_team' do
    it 'returns the error message correctly' do
      team_id = '123'
      expected1 = 'Team ID (123) from the X-Team-ID HTTP header NOT found!'
      expected2 = 'Consider adding Team for ID (123) using the Admin app on the Teams page.'

      error_message = Team.error_message_for_team(team_id)
      expect(error_message).to include expected1
      expect(error_message).to include expected2
    end
  end
end
