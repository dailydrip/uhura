# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Receiver, type: :model do
  describe 'attributes' do
    it { is_expected.to respond_to(:first_name) }
    it { is_expected.to respond_to(:last_name) }
    it { is_expected.to respond_to(:to_name) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:mobile_number) }
  end

  describe 'email' do
    it 'has a valid email address' do
      receiver = FactoryBot.create(:receiver)
      expect(receiver.email).to match(URI::MailTo::EMAIL_REGEXP)
    end
  end
end
