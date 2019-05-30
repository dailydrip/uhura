# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Template, type: :model do
  describe 'fields' do
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:template_id) }
    it { is_expected.to respond_to(:sample_template_data) }
  end
end
