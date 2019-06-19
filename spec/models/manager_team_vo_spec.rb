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
        manager_team_vo = ManagerTeamVo.new(manager_team(manager_id: nil))
        expect(manager_team_vo.valid?).to eq(false)
      end

      it 'must have valid manager_name' do
        manager_team_vo = ManagerTeamVo.new(manager_team(manager_name: nil))
        expect(manager_team_vo.valid?).to eq(false)
      end

      it 'must have valid manager_email' do
        manager_team_vo = ManagerTeamVo.new(manager_team(manager_email: nil))
        expect(manager_team_vo.valid?).to eq(false)
      end

      it 'must have valid team_name' do
        manager_team_vo = ManagerTeamVo.new(manager_team(team_name: nil))
        expect(manager_team_vo.valid?).to eq(false)
      end

      describe 'when manager_team params are valid' do
        it 'is valid' do
          manager_team_vo = ManagerTeamVo.new(manager_team)
          expect(manager_team_vo.valid?).to eq(true)
        end
      end
    end
  end
end
