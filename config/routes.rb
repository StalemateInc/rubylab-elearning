# frozen_string_literal: true
require 'sidekiq/web'
Rails.application.routes.draw do
  root 'home#index'

  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users,
             path: 'auth',
             path_names: {
               sign_in: 'login',
               sign_out: 'logout',
               password: 'secret',
               confirmation: 'verification',
               unlock: 'unblock',
               registration: 'register',
               sign_up: 'sign_up'
             },
             controllers: {
               sessions: 'users/sessions',
               # omniauth_callbacks: 'users/omniauth_callbacks',
               unlocks: 'users/unlocks',
               registrations: 'users/registrations',
               passwords: 'users/passwords',
               confirmations: 'users/confirmations'
             }
  devise_scope :user do
    patch '/auth/verification', to: 'users/confirmations#update', as: :update_user_confirmation
  end
  resources :organizations do
    member do
      get '/requests', to: 'join_requests#index', as: :requests
      post '/requests', to: 'join_requests#create', as: :create_request
      put '/requests/:join_request_id/accept', to: 'join_requests#accept', as: :accept_request
      put '/requests/:join_request_id/decline', to: 'join_requests#decline', as: :decline_request
      delete '/requests/:join_request_id', to: 'join_requests#destroy', as: :cancel_request
    end
    resource :membership, only: :destroy
  end
  resources :courses
  resources :questions, only: :new
end
