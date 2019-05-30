# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Team, type: :model do
  describe 'fields' do
    it { is_expected.to respond_to(:name) }
  end
end
