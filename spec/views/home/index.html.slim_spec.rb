# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'home/index.html.slim', type: :view do
  it 'should display page correctly' do
    render
    expect(rendered).to match /Welcome/
  end
end
