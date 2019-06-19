# frozen_string_literal: true

class SendgridMailer
  include SendGrid

  def initialize
    @client = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY']).client
  end

  # rubocop:disable all
  def send_email(mail_vo)
    response = @client.mail._('send').post(request_body: mail_vo.to_json) # <= Send email!
    body = response.body.blank? ? '' : JSON.parse(response.body)
    {
      response: {
        body: body,
        x_message_id: response&.headers && response&.headers['x-message-id'] && response&.headers['x-message-id'][0],
        server_date: response&.headers && response&.headers['date'] && response&.headers['date'][0],
        status_code: response.status_code
      },
      mail: mail_vo
    }
  end
  # rubocop:enable all
end
