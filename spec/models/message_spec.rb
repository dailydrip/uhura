# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to(:msg_target) }
    it { is_expected.to belong_to(:sendgrid_msg).optional }
    it { is_expected.to belong_to(:clearstream_msg).optional }
    it { is_expected.to belong_to(:manager) }
    it { is_expected.to belong_to(:receiver) }
    it { is_expected.to belong_to(:team) }
    it { is_expected.to belong_to(:template) }
  end

  describe 'fields' do
    it { is_expected.to respond_to(:app) }
    it { is_expected.to respond_to(:manager) }
    it { is_expected.to respond_to(:app_id) }
    it { is_expected.to respond_to(:manager_id) }
  end
end
