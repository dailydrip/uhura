# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SendgridMsg, type: :model do
  describe 'fields' do
    it { is_expected.to respond_to(:sent_to_sendgrid) }
    it { is_expected.to respond_to(:mail_and_response) }
    it { is_expected.to respond_to(:got_response_at) }
    it { is_expected.to respond_to(:sendgrid_response) }
  end
end
