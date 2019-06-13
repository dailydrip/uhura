# frozen_string_literal: true

# class SendgridMailer < ActionMailer::Base
class SendgridMailer #< Module
  include SendGrid

  def initialize
    @client = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY']).client
  end

  def send_email(message_vo)
    template_data = message_vo.email_message
    template_data['email_subject'] = message_vo.email_subject
    # Populate attributes required for request
    mail = SendgridMail.new(
      from: message_vo.manager_email,
      subject: message_vo.email_subject,
      receiver_sso_id: message_vo.receiver_sso_id,
      template_id: message_vo.sendgrid_template_id,
      dynamic_template_data: template_data
    ).get

    # Send email
    response = @client.mail._('send').post(request_body: mail.to_json)
    body = response.body.blank? ? '' : JSON.parse(response.body)
    {
       response: {
         body: body,
         server_date: response&.headers && response&.headers['date'] && response&.headers['date'][0],
         status_code: response.status_code
       },
       mail: mail}
  end
end
