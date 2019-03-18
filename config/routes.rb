# frozen_string_literal: true

Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :sg_emails
    end
  end

  namespace :admin do
    resources :users

    root to: 'users#index'
  end
  devise_for :users
  root to: 'home#index'
end
