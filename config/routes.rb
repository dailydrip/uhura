# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  mount HighlandsAuth::Engine => "/highlands_sso", :as => "auth"

  namespace :site_admin, path: '/admin' do
      resources :api_keys
      resources :clearstream_msgs
      resources :managers
      resources :messages
      resources :sendgrid_msgs
      resources :teams
      resources :templates
      resources :receivers
      resources :users

      root to: "managers#index"
  end

  namespace :api do
    namespace :v1 do
      post '/web_hooks/sendgrid' => 'web_hooks#sendgrid'
      post '/web_hooks/clearstream' => 'web_hooks#clearstream'
      resources :messages do
        member do
          get 'status'
        end
      end
      resources :message_status, only: [:show]
      resources :invalid_message_status, only: [:show]
    end
  end

  root to: 'home#index'
end
