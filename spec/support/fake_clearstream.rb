# frozen_string_literal: true

class FakeClearstream < FakeExternalServer
  # Routes return stubbed json responses from fixtures

  # Messages
  get '/v1/messages' do
    json_response 200, 'get_all_messages'
  end

  get '/v1/messages/108047' do
    json_response 200, 'get_message'
  end

  post '/v1/messages' do
    json_response 200, 'post_message'
  end

  delete '/v1/messages/108047' do
    json_response 403, 'delete_message'
  end

  # Lists
  get '/v1/lists' do
    json_response 200, 'get_all_lists'
  end

  get '/v1/lists/25041' do
    json_response 200, 'get_list'
  end

  post '/v1/lists' do
    if @params['name'].eql?('Lavenar List')
      json_response 422, 'post_list__name_taken'
    else
      json_response 200, 'post_list'
    end
  end

  patch '/v1/lists/25041' do
    json_response 200, 'patch_list'
  end

  delete '/v1/lists/25056' do
    json_response 200, 'delete_list'
  end
end
