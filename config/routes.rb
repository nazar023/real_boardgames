# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :games

  root to: redirect('games')

  post '/games/:id', to: 'participants#create', as: :game_participants
  get '/id/:id', to: 'profiles#show', as: :user_profile
  post '/id/:id', to: 'friends#create', as: :user_friends
  patch '/id/:id', to: 'friends#update', as: :friend
end
