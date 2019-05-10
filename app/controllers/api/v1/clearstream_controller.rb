class Api::V1::ClearstreamController < Api::V1::ApiController
  def create

    puts ">> http://#{request.host}:#{request.port}:#{request.fullpath}"

    @message = Message.new

    @message.template_id = params[:template_id]
    @message.message_body   = params[:message_body]
    # Fields NOT required below:
    @message.lists          = params[:lists]
    if !params[:subscribers].nil?
      subscribers = []
      params[:subscribers].split(',').each do |i|
        subscribers << Subscriber.find(i.to_i)
      end
      @message.subscribers = subscribers
    end
    @message.schedule       = params[:schedule]
    @message.datetime       = params[:datetime]
    @message.timezone       = params[:timezone]
    @message.send_to_fb     = params[:send_to_fb]
    @message.send_to_tw     = params[:send_to_tw]

    if !@message.valid?
      error_json = return_error(@message.errors)
      render json: error_json, status: 422 # Unprocessable Entity
    else
      send_sms
    end
  end

  def show
    @message = Message.find(params[:id])
  end

  def index
    @offers = Clearstream::MessageClient.new(
        api_key: @api_key,
        public_token: @manager_public_token).all
  end

  def index




    @sg_emails = Message.all



  end

  private

  def sg_email_params
    params
        .require(:sg_email)
        .permit(
            :template_id,
            :message_body,
            :from_label,
            :to_label,
            :lists,
            :response_status_code,
            :response_body,
            # :response_parsed_body,
            :response_headers,
            :subscribers
        )
  end

  def send_sms

    body = {
        "template_id=": "Blue Sushi",
        "message_body": "Come in now for 50% off all rolls!",
        "lists": "1,2"
    }

    token = ENV['CLEARSTREAM_KEY']
    uri = "#{ENV['CLEARSTREAM_URL']}/messages"
    @request = Request.new(token: token, uri: uri, verb: :post, body: body)

    # Send email via SendGrid
    response = @request.call
    rsc = status_code(response.status_code)
    @message.response_status_code = rsc
    if @message.save!
      render json: return_success(@message, rsc), status: rsc
    else
      render json: return_error(@message.errors, rsc), status: rsc
    end
  rescue StandardError => err
    error_json = return_error("send_sms: #{err.message}")
    render json: error_json, status: rsc
  end

  def mail
    # Got valid input
    from    = SendGrid::Email.new(email: @message.template_id)
    to      = SendGrid::Email.new(email: @message.message_body)
    lists = @message.lists
    subscribers = SendGrid::Content.new(
        type: 'text/plain',
        value: @message.subscribers
    )
    @mail ||= SendGrid::Mail.new(from, lists, to, subscribers)
  end
end
