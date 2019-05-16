require 'rails_helper'

RSpec.describe Ulog, type: :model do
  describe 'attributes' do
    it { is_expected.to respond_to(:details) }
  end

  describe 'relations' do
    it { is_expected.to belong_to(:source) }
    it { is_expected.to belong_to(:event_type) }
  end
end
