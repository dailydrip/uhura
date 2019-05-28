# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
    # Seed tables
    app1 = Manager.create!(name: 'Sample - App 1', email: 'app1@highlands.org')
    app1.public_token = '42c50c442ee3ca01378e' # Set to specific value to match tests
    app1.save!
    api_key1 = ApiKey.create!(manager: app1)
    api_key1.auth_token = 'b1dcc4b8287a82fe8889' # Set to specific value to match tests
    api_key1.save!
    Team.create!(name: 'Leadership Team')
    Team.create!(name: 'Campus Pastor Team')
    Team.create!(name: 'Accounting Team')
    MsgTarget.create!(name: 'Sendgrid', description: 'External Email Service')
    MsgTarget.create!(name: 'Clearstream', description: 'External SMS Texting Service')
    Template.create!(name: 'Sample Template A', template_id: 'd-f986df533e514f978f4460bedca50db0', sample_template_data: '{
      "header": Faker::Games::Pokemon.move.titleize,
      "section1": Faker::Quote.matz,
      "button": Faker::Verb.base.capitalize
    }')
    Template.create!(name: 'Sample Template B', template_id: 'd-4d10bf26b57247deba602127dab1ba60', sample_template_data: '{
      "header": Faker::Games::Pokemon.move.titleize,
      "section1": Faker::Quote.matz,
      "section2": Faker::Quote.matz,
      "button": Faker::Verb.base.capitalize
    }')
    Template.create!(name: 'Sample Template C', template_id: 'd-211d56caaf0544038d353a98ece2b367', sample_template_data: '{
      "header": Faker::Games::Pokemon.move.titleize,
      "section1": Faker::Quote.matz,
      "section2": Faker::Quote.matz,
      "section3": Faker::Quote.matz,
      "button": Faker::Verb.base.capitalize
    }')
    # Alice prefers SMS
    Receiver.create!(
      receiver_sso_id: '34430309',
      email: 'alice@aol.com',
      mobile_number: '9999999999',
      first_name: 'Alice',
      last_name: 'Green',
      preferences: { email: false, sms: true }
    )
    # Bob prefers Email
    Receiver.create!(
      receiver_sso_id: '55357499',
      email: 'bob@gmail.com',
      mobile_number: '5555555555',
      first_name: 'Bob',
      last_name: 'Brown',
      preferences: { email: true, sms: false }
    )
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
