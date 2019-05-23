# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MsgTarget, type: :model do
  describe 'fields' do
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:description) }
  end
end
