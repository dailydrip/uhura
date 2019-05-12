require 'rails_helper'

RSpec.describe Receiver, type: :model do
  describe 'attributes' do
    it { is_expected.to respond_to(:email) }
    it { is_expected.to respond_to(:mobile_number) }
  end
end
