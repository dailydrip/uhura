# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do

  namespace :admin do
      resources :api_keys
      resources :clearstream_msgs
      resources :event_types
      resources :managers
      resources :messages
      resources :sendgrid_msgs
      resources :sources
      resources :teams
      resources :templates
      resources :ulogs
      resources :users

      root to: "managers#index"
    end
  namespace :api do
    namespace :v1 do
      resources :messages
    end
  end
end
