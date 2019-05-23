# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Message, type: :model do

  describe 'Associations' do
    it { should belong_to(:msg_target) }
    it { should belong_to(:sendgrid_msg).optional }
    it { should belong_to(:clearstream_msg).optional }
    it { should belong_to(:manager) }
    it { should belong_to(:receiver) }
    it { should belong_to(:team) }
    it { should belong_to(:template) }
  end

  describe 'fields' do
    it { is_expected.to respond_to(:app) }
    it { is_expected.to respond_to(:manager) }
    it { is_expected.to respond_to(:app_id) }
    it { is_expected.to respond_to(:manager_id) }
  end
end
