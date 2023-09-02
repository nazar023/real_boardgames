# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :games

  root to: redirect('games')

  patch '/games/:id/choose_winner', to: 'games#choose_winner', as: :choose_winner
  post '/games/:id', to: 'participants#create', as: :game_participants
  get '/id/:id', to: 'profiles#show', as: :user_profile
  post '/id/:id', to: 'friends#create', as: :user_friends
  patch '/id/:id', to: 'friends#update', as: :friend
  delete '/notification/:id', to: 'notifications#destroy', as: :notification_destroy

  post '/games/:id/game_invites', to: 'notifications#create_user_invite', as: :game_invites

  post '/game_invites/:id/accept', to: 'notifications#accept_invite', as: :accept_invite
  delete '/game_invites/:id/decline', to: 'notifications#decline_invite', as: :decline_invite
end
