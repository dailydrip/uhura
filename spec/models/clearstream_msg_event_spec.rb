# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ClearstreamMsgEvent, type: :model do
  it { is_expected.to respond_to(:clearstream_msg_id) }
  it { is_expected.to respond_to(:status) }
  it { is_expected.to respond_to(:event) }
end
