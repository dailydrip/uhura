# frozen_string_literal: true

class Api::V1::MessagesController < Api::V1::ApiController
  RESOURCE = 'messages'

  def index
    @messages = ClearstreamClient::MessageClient.new(api_key: @api_key,
                                                     resource: RESOURCE).index
  end

  def create
    @message = ClearstreamClient::Message.new(params)
    if !@message.valid?
      error_json = return_error(@message.errors)
      render json: error_json, status: 422 # Unprocessable Entity
    else
      # Send message and render app/views/api/v1/messages/create.json.jbuilder view
      ClearstreamClient::MessageClient.new(data: @message,
                                           resource: RESOURCE).create
    end
  end

  def show
    @message = ClearstreamClient::MessageClient.new(api_key: @api_key,
                                                    resource: RESOURCE).show(params[:id])
  end

  def destroy
    @message = ClearstreamClient::MessageClient.new(api_key: @api_key,
                                                    resource: RESOURCE).destroy(params[:id])
  end
end
