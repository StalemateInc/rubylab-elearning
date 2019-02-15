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

  # get '/invites', to: 'invites#index', as: :invites
  # post '/invites/:id', to: 'invites#create', as: :accept_invite
  # delete '/invites/:id', to: 'invites#destroy', as: :destroy_invite


  resources :organizations do
    member do
      # user actions for organizations
      delete '/leave', to: 'organizations#leave', as: :leave
      # org_admin actions for organizations
      scope :manage do
        get '/', to: 'organization_dashboard#index', as: :home_dashboard
        scope :requests do
          get '/', to: 'organizations/join_requests#index', as: :requests
          post '/', to: 'organizations/join_requests#create', as: :create_request
          get '/:join_request_id/specify', to: 'organizations/join_requests#specify_reason', as: :specify_reason_request
          put '/:join_request_id/accept', to: 'organizations/join_requests#accept', as: :accept_request
          put '/:join_request_id/decline', to: 'organizations/join_requests#decline', as: :decline_request
          delete '/:join_request_id', to: 'organizations/join_requests#destroy', as: :destroy_request
        end
        scope :invites do; end
        scope :reports do
          get '/', to: 'reports#index', as: :reports
        end
        get '/memberships', to: 'memberships#index', as: :memberships
        delete '/memberships/:membership_id', to: 'memberships#destroy', as: :destroy_membership
      end
    end
  end
  resources :courses
  scope :user do
    get '/', to: 'user_dashboard#index', as: :user_dashboard
    resource :profile, only: %i[show edit update]
    resources :participations, only: %i[index destroy]
    resources :certificates, only: %i[index show]
    scope :invites do
      get '/', to: 'users/invites#index', as: :invites_user
      put '/:invite_id/accept', to: 'users/invites#accept', as: :accept_invite_user
      put '/:invite_id/decline', to: 'users/invites#decline', as: :decline_invite_user
    end
    get '/requests', to: 'users/join_requests#index', as: :requests_history
    delete '/requests/:join_request_id', to: 'users/join_requests#destroy', as: :cancel_request
  end
end
