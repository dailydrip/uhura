class Api::V1::SgEmailsController < Api::V1::ApiController

  def create
    @sg_email = SgEmail.new

    @sg_email.from_email  = params[:from_email]
    @sg_email.to_email    = params[:to_email]
    @sg_email.subject     = params[:subject]
    @sg_email.content     = params[:content]

    if !@sg_email.valid?
      render :json => { error: @sg_email.errors.full_messages,
                        status: :unprocessable_entity}
    else
      # Got valid input
      from    = SendGrid::Email.new(email: @sg_email.from_email)
      to      = SendGrid::Email.new(email: @sg_email.to_email)
      subject = @sg_email.subject
      content = SendGrid::Content.new(type: 'text/plain',
                                      value: @sg_email.content)
      mail = SendGrid::Mail.new(from, subject, to, content)

      # Create a new API Client to send the new email
      sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])

      begin
        # Send email via SendGrid
        response = sg.client.mail._('send').post request_body: mail.to_json
        if @sg_email.save!
          render json: @sg_email, status: :created
        else
          render json: {error: @sg_email.errors.full_messages}, status: :not_found
        end
        "Email sent. #{response.status_code} #{response.body}"
      rescue StandardError => err
        render json: return_error("SendGrid: #{err.message}}")
      end
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
    params.require(:sg_email).permit(:from_email,
                            :to_email,
                            :from_label,
                            :to_label,
                            :subject,
                            :response_status_code,
                            :response_body,
#                            :response_parsed_body,
                            :response_headers,
                            :content)
  end

end
