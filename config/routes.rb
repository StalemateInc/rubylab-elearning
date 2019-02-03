# frozen_string_literal: true
require 'sidekiq/web'
Rails.application.routes.draw do
  root 'home#index'
  devise_for :users

  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
