# rubocop:disable Rails/Output

def log(msg)
  Rails.logger.info msg
  puts msg
  # Source and Event tables must be populated before creating an Ulog entry.
  if !!defined? CLI_SOURCE_TYPE_ID
    Ulog.create!(source_id: CLI_SOURCE_TYPE_ID, event_type_id: INFO_EVENT_TYPE_ID, details: msg)
  end
end

log '1. Seeding Sources'
uhura_server = Source.create!(
    name: 'Uhura Server',
    details: {home_page_url: 'https://www.dailydrip.com/', api_reference_url: 'https://github.com/dailydrip/uhura'}
)

uhura_client = Source.create!(
    name: 'Uhura Client',
    details: {home_page_url: 'https://www.dailydrip.com/', api_reference_url: 'https://github.com/dailydrip/uhura'}
)

uhura_admin_app = Source.create!(
    name: 'Uhura SuperAdmin App',
    details: {home_page_url: 'https://www.dailydrip.com/', api_reference_url: 'https://github.com/dailydrip/uhura'}
)

uhura_cli = Source.create!(
    name: 'Uhura CLI',
    details: {home_page_url: 'https://www.dailydrip.com/', api_reference_url: 'https://github.com/dailydrip/uhura'}
)

sendgrid = Source.create!(
    name: 'SendGrid',
    details: {home_page_url: 'https://sendgrid.com/', api_reference_url: 'https://sendgrid.com/docs/api-reference/'}
)
clearstram = Source.create!(
    name: 'Clearstream',
    details: {home_page_url: 'https://clearstream.io/', api_reference_url: 'https://sendgrid.com/docs/api-reference/'}
)

log '2. Seeding EventTypes'
evt_info = EventType.create!(name: 'Log Info', label: 'INF', description: 'Information about normal events')
evt_err = EventType.create!(name: 'Log Error', label: 'ERR', description: 'Information about errors')
evt_wrn = EventType.create!(name: 'Log Warning', label: 'WRN', description: 'Information about abnormal/unexpected events that are not errors')

CLI_SOURCE_TYPE_ID = uhura_cli.id
INFO_EVENT_TYPE_ID = evt_info.id

log '3. Seeding Managers (Apps)'
app1 = Manager.create!(name: 'Sample - App 1', email: 'app1@highlands.org')
m1 = Manager.find(1);m1.public_token = SecureRandom.hex(10);m1.save!
app2 = Manager.create!(name: 'Sample - App 2', email: 'app2@highlands.org')
m2 = Manager.find(2);m2.public_token = SecureRandom.hex(10);m2.save!

log '4. Seeding ApiKeys'
ApiKey.create!(manager: app1)
ApiKey.create!(manager: app2)

log "5. Seeding Teams"
team_sta = Team.create!(name: 'Sample Team A', name_prefix: 'STA', email: 'team.a@highlands.org')
team_stb = Team.create!(name: 'Sample Team B', name_prefix: 'STB', email: 'team.b@highlands.org')

log "6. Seeding Templates"
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

log "7. Seeding Users"
alice = Receiver.create!(
  email: 'alice@aol.com',
  mobile_number: '4048844201',
  first_name: 'Alice',
  last_name: 'Green'
)
bob = Receiver.create!(
  email: 'bob@hotmail.com',
  mobile_number: '4048844202',
  first_name: 'Bob',
  last_name: 'Blue'

)
cindy = Receiver.create!(
  email: 'cindy@msn.com',
  mobile_number: '4048844203',
  first_name: 'Cindy',
  last_name: 'Red'

)

log "8. Seeding Messages"
msg1 = Message.create!(manager_id: app1.id, # <= source (an application)
                       team_id: team_sta.id, # <= message coming from this team
                       receiver_id: bob.id, # <= receiver (a user)
                       email_subject: 'Sample - Picnic this Saturday',
                       email_message: {headers: {key1: 'val1', key2: 'val2'}, sections: {name: 'val1', body: 'val2'}},
                       template_id: template_a.id,
                       sms_message:  'Sample - Picnic this Saturday. Bring drinks.')

msg2 = Message.create!(manager_id: app1.id,
                       team_id: team_stb.id,
                       receiver_id: bob.id,
                       email_subject: 'Sample - Fund Raiser',
                       email_message: {headers: {key1: 'val1', key2: 'val2'}, sections: {key1: 'val1', key2: 'val2'}},
                       template_id: template_b.id,
                       sms_message:  'Sample - Fund raiser this week. Be generous.')

msg3 = Message.create!(manager_id: app1.id,
                       team_id: team_sta.id,
                       receiver_id: cindy.id,
                       email_subject: 'Sample - Picnic this Saturday',
                       email_message: {headers: {key1: 'val1', key2: 'val2'}, sections: {key1: 'val1', key2: 'val2'}},
                       template_id: template_a.id,
                       sms_message:  'Sample - Picnic this Saturday. Bring drinks.')

msg4 = Message.create!(manager_id: app2.id,
                       team_id: team_sta.id,
                       receiver_id: alice.id, # <= receiver (a user)
                       email_subject: 'Sample - Picnic this Saturday',
                       email_message: {headers: {key1: 'val1', key2: 'val2'}, sections: {key1: 'val1', key2: 'val2'}},
                       template_id: template_a.id,
                       sms_message:  'Sample - Picnic this Saturday. Bring drinks.')

msg5 = Message.create!(manager_id: app2.id,
                       team_id: team_stb.id,
                       receiver_id: alice.id, # <= receiver (a user)
                       email_subject: 'Sample - W2 Available',
                       email_message: {headers: {key1: 'val1', key2: 'val2'}, sections: {key1: 'val1', key2: 'val2'}},
                       template_id: template_c.id,
                       sms_message:  'Sample - Get your W2 from https://benefits.example.com')

msg6 = Message.create!(manager_id: app2.id,
                       team_id: team_sta.id,
                       receiver_id: cindy.id, # <= receiver (a user)
                       email_subject: 'Sample - Choir Practice Tonight!',
                       email_message: {headers: {key1: 'val1', key2: 'val2'}, sections: {key1: 'val1', key2: 'val2'}},
                       template_id: template_a.id,
                       sms_message:  'Sample - Choir practice tonight at 7:00 p.m.')

log "9. Seeding SendgridMsg and ClearstreamMsg"
sg1 = SendgridMsg.create!(sent_to_sendgrid: Time.now,
                          sendgrid_response: '',
                          read_by_user_at: 1.day.from_now)
msg1.sendgrid_msg = sg1

sg2 = SendgridMsg.create!(sent_to_sendgrid: 1.minute.from_now,
                          sendgrid_response: '',
                          read_by_user_at: 2.days.from_now)
msg2.sendgrid_msg = sg2

cs1 = ClearstreamMsg.create!(sent_to_clearstream: 2.minutes.from_now,
                             clearstream_response: '')
msg3.clearstream_msg = cs1

sg3 = SendgridMsg.create!(sent_to_sendgrid: 3.minutes.from_now,
                          sendgrid_response: '',
                          read_by_user_at: nil)
msg4.sendgrid_msg = sg3

cs2 = ClearstreamMsg.create!(sent_to_clearstream: 4.minutes.from_now,
                             clearstream_response: '')
msg4.clearstream_msg = cs2

sg4 = SendgridMsg.create!(sent_to_sendgrid: 5.minutes.from_now,
                          sendgrid_response: '',
                          read_by_user_at: 3.days.from_now)
msg5.sendgrid_msg = sg4

cs3 = ClearstreamMsg.create!(sent_to_clearstream: 6.minutes.from_now,
                             clearstream_response: '')
msg5.clearstream_msg = cs3

cs4 = ClearstreamMsg.create!(sent_to_clearstream: 7.minutes.from_now,
                             clearstream_response: '')
msg6.clearstream_msg = cs4

log 'Seeding Done!'
