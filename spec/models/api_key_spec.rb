# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApiKey, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:manager) }
  end

  describe 'relations' do
    it { is_expected.to belong_to(:manager) }
  end

  describe 'callbacks' do
    it 'has an auth_token after creation' do
      api_key = FactoryBot.create(:api_key)
      expect(api_key.auth_token).to_not be_nil
    end
  end
end
