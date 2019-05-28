# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ManagerTeamVo, type: :model do
  describe 'validations' do
    before(:each) do
      @manager_team = {
        manager_id: 1,
        manager_name: 'Picnic Saturday',
        manager_email: 'app1@highlands.org',
        team_name: 'Leadership Team'
      }
    end

    def manager_team(new_params = {})
      @manager_team.merge(new_params)
    end

    context 'initialization' do
      it 'must have valid manager_id' do
        expect do
          ManagerTeamVo.new(manager_team(manager_id: nil))
        end.to raise_error(ManagerTeamVo::InvalidManagerTeam, /invalid manager_team_vo/)
      end

      it 'must have valid manager_name' do
        expect do
          ManagerTeamVo.new(manager_team(manager_name: nil))
        end.to raise_error(ManagerTeamVo::InvalidManagerTeam, /invalid manager_team_vo/)
      end

      it 'must have valid manager_email' do
        expect do
          ManagerTeamVo.new(manager_team(manager_email: nil))
        end.to raise_error(ManagerTeamVo::InvalidManagerTeam, /invalid manager_team_vo/)
      end

      it 'must have valid team_name' do
        expect do
          ManagerTeamVo.new(manager_team(team_name: nil))
        end.to raise_error(ManagerTeamVo::InvalidManagerTeam, /invalid manager_team_vo/)
      end

      describe 'when manager_team params are valid' do
        it 'does not raise any exception' do
          expect do
            ManagerTeamVo.new(manager_team).not_to raise_error
          end
        end
      end
    end
  end
end
