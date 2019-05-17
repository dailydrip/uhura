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
    ApiKey.create!(manager: app1)
    leadership_team = Team.create!(name: 'Leadership Team')
    campus_pastor_team = Team.create!(name: 'Campus Pastor Team')
    accounting_team = Team.create!(name: 'Accounting Team')
    evt_info = EventType.create!(name: 'Log Info', label: 'INF', description: 'Information about normal events')
    evt_err = EventType.create!(name: 'Log Error', label: 'ERR', description: 'Information about errors')
    evt_wrn = EventType.create!(name: 'Log Warning', label: 'WRN', description: 'Information about abnormal/unexpected events that are not errors')
    MsgTarget.create!(name: 'Sendgrid', description: 'External Email Service')
    MsgTarget.create!(name: 'Clearstream', description: 'External SMS Texting Service')
    template_a = Template.create!(name: 'Sample Template A', template_id: 'd-f986df533e514f978f4460bedca50db0', sample_template_data: '{
      "header": Faker::Games::Pokemon.move.titleize,
      "section1": Faker::Quote.matz,
      "button": Faker::Verb.base.capitalize
    }')
    template_b = Template.create!(name: 'Sample Template B', template_id: 'd-4d10bf26b57247deba602127dab1ba60', sample_template_data: '{
      "header": Faker::Games::Pokemon.move.titleize,
      "section1": Faker::Quote.matz,
      "section2": Faker::Quote.matz,
      "button": Faker::Verb.base.capitalize
    }')
    template_c = Template.create!(name: 'Sample Template C', template_id: 'd-211d56caaf0544038d353a98ece2b367', sample_template_data: '{
      "header": Faker::Games::Pokemon.move.titleize,
      "section1": Faker::Quote.matz,
      "section2": Faker::Quote.matz,
      "section3": Faker::Quote.matz,
      "button": Faker::Verb.base.capitalize
    }')
    rspec = Source.create!(
        name: 'Rspec',
        details: {home_page_url: 'http://www.betterspecs.org/'}
    )
    alice = Receiver.create!(
        receiver_sso_id: Faker::Number.number(digits = 8),
        email: Faker::Internet.email,
        mobile_number: Faker::PhoneNumber.cell_phone,
        first_name: 'Alice',
        last_name: 'Green',
        preferences: {email: false, sms: true}
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
