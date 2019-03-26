# frozen_string_literal: true

class Api::V1::SgEmailsController < Api::V1::ApiController
  def create
    @sg_email = SgEmail.new

    @sg_email.from_email  = params[:from_email]
    @sg_email.to_email    = params[:to_email]
    @sg_email.subject     = params[:subject]
    @sg_email.content     = params[:content]

    if !@sg_email.valid?
      error_json = return_error(@sg_email.errors)
      render json: error_json, status: 422 # Unprocessable Entity
    else
      send_via_sendgrid
    end
  end

  def show
    @sg_email = SgEmail.find(params[:id])
  end

  def index
    @sg_emails = SgEmail.all
  end

  private

  def sg_email_params
    params
      .require(:sg_email)
      .permit(
        :from_email,
        :to_email,
        :from_label,
        :to_label,
        :subject,
        :response_status_code,
        :response_body,
        # :response_parsed_body,
        :response_headers,
        :content
      )
  end

  def send_via_sendgrid
    # Create a new API Client to send the new email
    sg = SendGrid::API.new(api_key: Rails.application.credentials.sendgrid[:api_key])

    # Send email via SendGrid
    response = sg.client.mail._('send').post request_body: mail.to_json
    rsc = status_code(response.status_code)
    @sg_email.response_status_code = rsc
    if @sg_email.save!
      render json: return_success(@sg_email, rsc), status: rsc
    else
      render json: return_error(@sg_email.errors, rsc), status: rsc
    end
  rescue StandardError => err
    error_json = return_error("send_via_sendgrid: #{err.message}")
    render json: error_json, status: rsc
  end

  def mail
    # Got valid input
    from    = SendGrid::Email.new(email: @sg_email.from_email)
    to      = SendGrid::Email.new(email: @sg_email.to_email)
    subject = @sg_email.subject
    content = SendGrid::Content.new(
      type: 'text/plain',
      value: @sg_email.content
    )
    @mail ||= SendGrid::Mail.new(from, subject, to, content)
  end
end
