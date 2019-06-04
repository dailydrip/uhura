# Seed tables
def setup_data
  app1 = Manager.create!(name: 'Sample - App 1', email: 'app1@highlands.org')
  app1.public_token = '42c50c442ee3ca01378e' # Set to specific value to match tests
  app1.save!
  api_key1 = ApiKey.create!(manager: app1)
  api_key1.auth_token = 'b1dcc4b8287a82fe8889' # Set to specific value to match tests
  api_key1.save!
  leadership_team = Team.create!(name: 'Leadership Team')
  campus_pastor_team = Team.create!(name: 'Campus Pastor Team')
  accounting_team = Team.create!(name: 'Accounting Team')
  MsgTarget.create!(name: 'Sendgrid', description: 'External Email Service')
  MsgTarget.create!(name: 'Clearstream', description: 'External SMS Texting Service')
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
  # Alice prefers SMS
  alice = Receiver.create!(
      receiver_sso_id: '34430309',
      email: 'alice@aol.com',
      mobile_number: '9999999999',
      first_name: 'Alice',
      last_name: 'Green',
      preferences: { email: false, sms: true }
  )
  # Bob prefers Email
  bob = Receiver.create!(
      receiver_sso_id: '55357499',
      email: 'bob@gmail.com',
      mobile_number: '5555555555',
      first_name: 'Bob',
      last_name: 'Brown',
      preferences: { email: true, sms: false }
  )

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

  msg2 = Message.create!(msg_target_id: MsgTarget.find_by(name: 'Clearstream').id,
                         manager_id: app1.id,
                         team_id: leadership_team.id,
                         receiver_id: alice.id,
                         email_subject: Faker::TvShows::SiliconValley.motto,
                         email_message:  {
                             "header": Faker::Games::Pokemon.move.titleize,
                             "section1": Faker::Quote.matz,
                             "button": Faker::Verb.base.capitalize
                         },
                         template_id: template_a.id,
                         sms_message:  Faker::Movie.quote)

  sendgrid_msg = SendgridMsg.create!(sent_to_sendgrid: Time.now,
                            mail_and_response: {
                                "mail": {
                                    "from": {
                                        "email": "app1@highlands.org"
                                    },
                                    "subject": "Picnic Saturday",
                                    "personalizations": [
                                        {
                                            "to": [
                                                {
                                                    "email": "bob.replace.me@gmail.com",
                                                    "name": "Bob Brown"
                                                }
                                            ],
                                            "dynamic_template_data": {
                                                "header": "Dragon Rage",
                                                "section1": "imagine you are writing an email. you are in front of the computer. you are operating the computer, clicking a mouse and typing on a keyboard, but the message will be sent to a human over the internet. so you are working before the computer, but with a human behind the computer.",
                                                "button": "Count me in!",
                                                "email_subject": "Picnic Saturday"
                                            }
                                        }
                                    ],
                                    "template_id": "d-f986df533e514f978f4460bedca50db0"
                                },
                                "response": {
                                    "date": "Sun, 02 Jun 2019 22:39:53 GMT",
                                    "body": ""
                                }
                            },
                            got_response_at: nil,
                            sendgrid_response: nil,
                            read_by_user_at: 1.day.from_now)
  msg1.sendgrid_msg = sendgrid_msg
  msg1.save!

  cs1 = ClearstreamMsg.create!(sent_to_clearstream: 2.minutes.from_now,
                               response:{
                                   "id": 122476,
                                   "status": "QUEUED",
                                   "sent_at": "2019-06-04T01:31:06+00:00",
                                   "text": {
                                       "full": "Leadership Team: Come in now for 50% off all rolls!",
                                       "header": "Leadership Team",
                                       "body": "Come in now for 50% off all rolls!"
                                   },
                                   "lists": [],
                                   "subscribers": [
                                       "+17707651573"
                                   ],
                                   "stats": {
                                       "recipients": 1,
                                       "failures": 0,
                                       "throughput": 0,
                                       "replies": 0,
                                       "opt_outs": 0
                                   },
                                   "social": {
                                       "twitter": {
                                           "enabled": false
                                       },
                                       "facebook": {
                                           "enabled": false
                                       }
                                   }
                               },
                               got_response_at: 2.seconds.from_now,
                               status: 'QUEUED')
  msg2.clearstream_msg = cs1
  msg2.save!
end