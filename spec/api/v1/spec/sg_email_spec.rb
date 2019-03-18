require "#{__dir__}/../requests/sg_email_api.rb"
require "#{__dir__}/with_fake_server.rb"
require 'awesome_print'
require 'rails_helper'

RSpec.describe SgEmailApi do

  around &method(:with_fake_server)

  attr_accessor :sg_email

  describe '.post' do
    it 'returns a valid SgEmail object' do
      api_sg_email = SgEmailApi.post
      expect(api_sg_email[:status]).to eq '200'
    end
  end

  # describe '.get' do
  #   it 'returns a valid SgEmail object' do
  #     sg_email = SgEmailApi.get(1)
  #
  #     expect(sg_email.id).to eq 1
  #     expect(sg_email.from_email).to eq 'alice@gmail.com'
  #     expect(sg_email.to_email).to eq 'bob@gmail.com'
  #     expect(sg_email.subject).to eq 'A test from Rails'
  #     expect(sg_email.content).to eq 'How r u?'
  #     expect(sg_email.response_status_code).to eq '202'
  #   end
  # end

end
