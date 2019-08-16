# frozen_string_literal: true

require 'awesome_print'

# # using SendGrid's Ruby Library
# # https://github.com/sendgrid/sendgrid-ruby
# require 'sendgrid-ruby'
# include SendGrid
#
# # from = Email.new(email: 'test@example.com')
# # to = Email.new(email: 'test@example.com')
# from = Email.new(email: 'bob.p.k.brown@gmail.com')
# to = Email.new(email: 'bob.p.k.brown@gmail.com')
# subject = 'Sending with SendGrid is Fun'
# content = Content.new(type: 'text/plain', value: 'and easy to do anywhere, even with Ruby')
# mail = Mail.new(from, subject, to, content)
#
# sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
#
# puts '>> mail'
# ap mail
#
# response = sg.client.mail._('send').post(request_body: mail.to_json)
# puts response.status_code
# puts response.body
# puts response.headers



message = UhuraClient::Message.new(
    receiver_sso_id: "id",
    email: UhuraClient::Email.new(
        subject: "Yo!",
        message: "Yo!",
        options: UhuraClient::EmailOptions.new(cc: "someoneelse@example.com")
    ),
    template_id: "template_id",
    sms_message: "Yo!"
)

puts '>> message'
ap message