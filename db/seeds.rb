# rubocop:disable Rails/Output

require 'faker'

log! '1. Seeding Managers (Apps)'
app1 = Manager.create!(name: 'Sample - App 1', email: 'app1@highlands.org')
app1.public_token = '42c50c442ee3ca01378e'       # Set to specific value to match tests
app1.save!
app2 = Manager.create!(name: 'Sample - App 2', email: 'app2@highlands.org')
app2.public_token = SecureRandom.hex(10)
app2.save!

log! '2. Seeding ApiKeys'
api_key1 = ApiKey.create!(manager: app1)
api_key1.auth_token = 'b1dcc4b8287a82fe8889' # Set to specific value to match tests
api_key1.save!
ApiKey.create!(manager: app2)

log! "3. Seeding Teams"
leadership_team = Team.create!(name: 'Leadership Team')
campus_pastor_team = Team.create!(name: 'Campus Pastor Team')
accounting_team = Team.create!(name: 'Accounting Team')

log! "4. Seeding Templates"
template_a = Template.create!(name: 'Sample Template A', template_id: 'd-f986df533e514f978f4460bedca50db0', sample_template_data: {
  "header": Faker::Games::Pokemon.move.titleize,
  "section1": Faker::Quote.matz,
  "button": Faker::Verb.base.capitalize
})
template_b = Template.create!(name: 'Sample Template B', template_id: 'd-4d10bf26b57247deba602127dab1ba60', sample_template_data: {
  "header": Faker::Games::Pokemon.move.titleize,
  "section1": Faker::Quote.matz,
  "section2": Faker::Quote.matz,
  "button": Faker::Verb.base.capitalize
})
template_c = Template.create!(name: 'Sample Template C', template_id: 'd-211d56caaf0544038d353a98ece2b367', sample_template_data: {
  "header": Faker::Games::Pokemon.move.titleize,
  "section1": Faker::Quote.matz,
  "section2": Faker::Quote.matz,
  "section3": Faker::Quote.matz,
  "button": Faker::Verb.base.capitalize
})

log! "5. Seeding Users"
# Receivers is a temporary table.  When we get the data from Highlands SSO we'll remove the receivers table.
alice = Receiver.create!(
  receiver_sso_id: '34430309',
  email: 'alice@aol.com',
  mobile_number: '9999999999',
  first_name: 'Alice',
  last_name: 'Green',
  preferences: {email: false, sms: true}
)
bob = Receiver.create!(
  receiver_sso_id: '55357499',
  email: 'bob.replace.me@gmail.com',
  mobile_number: Faker::PhoneNumber.cell_phone,
  first_name: 'Bob',
  last_name: 'Brown',
  preferences: {email: true, sms: false}
)
cindy = Receiver.create!(
  receiver_sso_id: Faker::Number.number(digits = 8),
  email: 'cindy@yahoo.com',
  mobile_number: Faker::PhoneNumber.cell_phone,
  first_name: 'Cindy',
  last_name: 'Red',
  preferences: {email: false, sms: true}
)

log! "6. Seeding MsgTarget"
MsgTarget.create!(name: 'Sendgrid', description: 'External Email Service')
MsgTarget.create!(name: 'Clearstream', description: 'External SMS Texting Service')

log! "7. Seeding Messages"
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

log! "8. Seeding SendgridMsg and ClearstreamMsg"
sg1 = SendgridMsg.create!(sent_to_sendgrid: Time.now, read_by_user_at: 1.day.from_now)
msg1.sendgrid_msg = sg1
msg1.save!

sg2 = SendgridMsg.create!(sent_to_sendgrid: 1.minute.from_now, read_by_user_at: 2.days.from_now)
msg2.sendgrid_msg = sg2
msg2.save!

cs1 = ClearstreamMsg.create!(sent_to_clearstream: 2.minutes.from_now)
msg3.clearstream_msg = cs1
msg3.save!

cs2 = ClearstreamMsg.create!(sent_to_clearstream: 4.minutes.from_now)
msg4.clearstream_msg = cs2
msg4.save!

sg3 = SendgridMsg.create!(sent_to_sendgrid: 5.minutes.from_now, read_by_user_at: 3.days.from_now)
msg5.sendgrid_msg = sg3
msg5.save!

cs3 = ClearstreamMsg.create!(sent_to_clearstream: 7.minutes.from_now)
msg6.clearstream_msg = cs3
msg6.save!

log! 'Seeding Done!'
log! "public_token: #{Manager.first.public_token}"
log_secure! "Authorization Bearer token: #{Manager.first.api_key.auth_token}"
