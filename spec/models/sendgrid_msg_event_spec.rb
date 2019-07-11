# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SendgridMsgEvent, type: :model do
  it { is_expected.to respond_to(:sendgrid_msg_id) }
  it { is_expected.to respond_to(:status) }
  it { is_expected.to respond_to(:event) }
end
