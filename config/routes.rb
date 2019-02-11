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
      # user actions for organizations
      delete '/leave', to: 'organizations#leave', as: :leave
      # org_admin actions for organizations
      scope :manage do
        get '/', to: 'organization_dashboard#index', as: :home_dashboard
        scope :requests do
          get '/', to: 'join_requests#index', as: :requests
          post '/', to: 'join_requests#create', as: :create_request
          put '/:join_request_id/accept', to: 'join_requests#accept', as: :accept_request
          put '/:join_request_id/decline', to: 'join_requests#decline', as: :decline_request
          delete '/:join_request_id', to: 'join_requests#destroy', as: :cancel_request
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
  end
end
