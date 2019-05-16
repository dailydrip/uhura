# rubocop:disable Rails/Output

require 'faker'

def log(msg)
  Rails.logger.info msg
  puts msg
  # Source and Event tables must be populated before creating an Ulog entry.
  if !!defined? CLI_SOURCE_TYPE_ID && !msg.include?('Authorization Bearer token')
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
leadership_team = Team.create!(name: 'Leadership Team')
campus_pastor_team = Team.create!(name: 'Campus Pastor Team')
accounting_team = Team.create!(name: 'Accounting Team')

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
# Receivers is a temporary table.  When we get the data from Highlands SSO we'll remove the receivers table.
alice = Receiver.create!(
  receiver_sso_id: '88543890',
  email: 'alice@aol.com',
  mobile_number: '7707651573',
  first_name: 'Alice',
  last_name: 'Green',
  preferences: {email: false, sms: true}
)
bob = Receiver.create!(
  receiver_sso_id: '88543891',
  email: 'bob.p.k.brown@gmail.com',
  mobile_number: '4048844202',
  first_name: 'Bob',
  last_name: 'Brown',
  preferences: {email: true, sms: false}
)
cindy = Receiver.create!(
  receiver_sso_id: '88543892',
  email: 'cindy@msn.com',
  mobile_number: '4048844203',
  first_name: 'Cindy',
  last_name: 'Red',
  preferences: {email: false, sms: true}
)


log "8. Seeding MsgTarget"
MsgTarget.create!(name: 'Sendgrid',
                  description: 'External Email Service')

MsgTarget.create!(name: 'Clearstream',
                  description: 'External SMS Texting Service')


log "9. Seeding Messages"
msg1 = Message.create!(msg_target_id: MsgTarget.find_by(name: 'Sendgrid').id,
                       manager_id: app1.id, # <= source (an application)
                       team_id: leadership_team.id, # <= message coming from this team
                       receiver_id: bob.id, # <= receiver (a user)
                       email_subject: Faker::TvShows::SiliconValley.motto,
                       email_message:  {
                           "header": Faker::Games::Pokemon.move.titleize,
                           "section1": Faker::Quote.matz,
                           "button": Faker::Verb.base.capitalize
                       },
                       template_id: template_a.id,
                       sms_message:  Faker::Movie.quote)

msg2 = Message.create!(msg_target_id: MsgTarget.find_by(name: 'Sendgrid').id,
                       manager_id: app1.id,
                       team_id: campus_pastor_team.id,
                       receiver_id: bob.id,
                       email_subject: Faker::TvShows::SiliconValley.motto,
                       email_message:  {
                           "header": Faker::Games::Pokemon.move.titleize,
                           "section1": Faker::Quote.matz,
                           "section2": Faker::Quote.matz,
                           "button": Faker::Verb.base.capitalize
                       },
                       template_id: template_b.id,
                       sms_message:  Faker::Movie.quote)

msg3 = Message.create!(msg_target_id: MsgTarget.find_by(name: 'Clearstream').id,
                       manager_id: app1.id,
                       team_id: leadership_team.id,
                       receiver_id: cindy.id,
                       email_subject: Faker::TvShows::SiliconValley.motto,
                       email_message:  {
                           "header": Faker::Games::Pokemon.move.titleize,
                           "section1": Faker::Quote.matz,
                           "button": Faker::Verb.base.capitalize
                       },
                       template_id: template_a.id,
                       sms_message:  Faker::Movie.quote)

msg4 = Message.create!(msg_target_id: MsgTarget.find_by(name: 'Clearstream').id,
                       manager_id: app2.id,
                       team_id: leadership_team.id,
                       receiver_id: alice.id, # <= receiver (a user)
                       email_subject: Faker::TvShows::SiliconValley.motto,
                       email_message:  {
                           "header": Faker::Games::Pokemon.move.titleize,
                           "section1": Faker::Quote.matz,
                           "button": Faker::Verb.base.capitalize
                       },
                       template_id: template_a.id,
                       sms_message:  Faker::Movie.quote)

msg5 = Message.create!(msg_target_id: MsgTarget.find_by(name: 'Sendgrid').id,
                       manager_id: app2.id,
                       team_id: campus_pastor_team.id,
                       receiver_id: bob.id, # <= receiver (a user)
                       email_subject: Faker::TvShows::SiliconValley.motto,
                       email_message:  {
                           "header": Faker::Games::Pokemon.move.titleize,
                           "section1": Faker::Quote.matz,
                           "section2": Faker::Quote.matz,
                           "section3": Faker::Quote.matz,
                           "button": Faker::Verb.base.capitalize
                       },
                       template_id: template_c.id,
                       sms_message:  Faker::Movie.quote)

msg6 = Message.create!(msg_target_id: MsgTarget.find_by(name: 'Clearstream').id,
                       manager_id: app2.id,
                       team_id: leadership_team.id,
                       receiver_id: cindy.id, # <= receiver (a user)
                       email_subject: Faker::TvShows::SiliconValley.motto,
                       email_message:  {
                           "header": Faker::Games::Pokemon.move.titleize,
                           "section1": Faker::Quote.matz,
                           "button": Faker::Verb.base.capitalize
                       },
                       template_id: template_a.id,
                       sms_message:  Faker::Movie.quote)

log "10. Seeding SendgridMsg and ClearstreamMsg"
sg1 = SendgridMsg.create!(sent_to_sendgrid: Time.now,
                          read_by_user_at: 1.day.from_now)
msg1.sendgrid_msg = sg1
msg1.save!

sg2 = SendgridMsg.create!(sent_to_sendgrid: 1.minute.from_now,
                          read_by_user_at: 2.days.from_now)
msg2.sendgrid_msg = sg2
msg2.save!

cs1 = ClearstreamMsg.create!(sent_to_clearstream: 2.minutes.from_now)
msg3.clearstream_msg = cs1
msg3.save!


cs2 = ClearstreamMsg.create!(sent_to_clearstream: 4.minutes.from_now)
msg4.clearstream_msg = cs2
msg4.save!

sg3 = SendgridMsg.create!(sent_to_sendgrid: 5.minutes.from_now,
                          read_by_user_at: 3.days.from_now)
msg5.sendgrid_msg = sg3
msg5.save!

cs3 = ClearstreamMsg.create!(sent_to_clearstream: 7.minutes.from_now)
msg6.clearstream_msg = cs3
msg6.save!

log 'Seeding Done!'
log "public_token: #{Manager.first.public_token}"
log "Authorization Bearer token: #{Manager.first.api_key.auth_token}"
