# frozen_string_literal: true

class Api::V1::ListsController < Api::V1::ApiController
  RESOURCE = 'lists'

  def index
    @lists = ClearstreamClient::BaseClient.new(api_key: @api_key,
                                               resource: RESOURCE).index
  end

  def create
    @list = ClearstreamClient::List.new(params)
    if !@list.valid?
      error_json = return_error(@list.errors)
      render json: error_json, status: 422
    else
      ClearstreamClient::BaseClient.new(data: @list.to_h,
                                        resource: RESOURCE).create
    end
  end

  def show
    @list = ClearstreamClient::BaseClient.new(api_key: @api_key,
                                              resource: RESOURCE).show(params[:id])
  end

  def destroy
    @list = ClearstreamClient::BaseClient.new(
      api_key: @api_key,
                                              resource: RESOURCE).destroy(params[:id])
  end

  def update
    @list = ClearstreamClient::List.new(params)
    if !@list.valid?
      error_json = return_error(@list.errors)
      render json: error_json, status: 422
    else
      @list = ClearstreamClient::BaseClient.new(api_key: @api_key,
                                                data: @list,
                                                resource: RESOURCE).patch(params[:id])
      puts "@list: #{@list}"
      @list
    end
  end
end
