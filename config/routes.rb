# frozen_string_literal: true

Rails.application.routes.draw do
  resources :friends
  resources :user do
    resources :friend_requests
    resources :friends
  end

  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :games do
    resources :participants
  end

  root to: redirect('games')
  get '/id/:id', to: 'profiles#show', as: :user_profile
end
