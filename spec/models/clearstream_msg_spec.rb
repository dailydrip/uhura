# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ClearstreamMsg, type: :model do
  describe 'fields' do
    it { is_expected.to respond_to(:sent_to_clearstream) }
    it { is_expected.to respond_to(:response) }
    it { is_expected.to respond_to(:got_response_at) }
    it { is_expected.to respond_to(:status) }
  end
end