# frozen_string_literal: true

class Spinach::Features::CheckTheHomePage < Spinach::FeatureSteps
  include RSpec::Matchers
  step 'I am on the home page' do
    visit '/'
  end

  step 'I can see the text welcome to Uhura!' do
    expect(page).to have_content(/Welcome to rails uhura!/i)
  end
end
