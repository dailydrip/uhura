# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Manager, type: :model do
  describe 'fields' do
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:public_token) }
    it { is_expected.to respond_to(:email) }
    it { is_expected.to respond_to(:api_keys) }
  end

  describe 'relations' do
    it { is_expected.to have_many(:api_keys) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'callbacks' do
    it 'has a public_token after creation' do
      manager = FactoryBot.create(:manager)
      expect(manager.public_token).to_not be_nil
    end
  end
end
