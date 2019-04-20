# frozen_string_literal: true

Rails.application.routes.draw do
  mount HighlandsAuth::Engine => "/highlands_sso", :as => "auth"

  namespace :api do
    namespace :v1 do
      resources :messages
      resources :lists
    end
  end

  namespace :admin do
    resources :users

    root to: 'users#index'
  end
  devise_for :users
  root to: 'home#index'
end
