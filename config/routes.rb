# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'

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
  resources :organizations

  get '/invites', to: 'invites#notificate', as: :invites
  post '/invites/:id', to: 'invites#accept', as: :accept_invite
  delete '/invites/:id', to: 'invites#destroy', as: :destroy_invite
end
