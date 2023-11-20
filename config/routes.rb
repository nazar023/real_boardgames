# frozen_string_literal: true

Rails.application.routes.draw do
  # devise_for :users, controllers: {
  #                                 registrations: 'users/registrations',
  #                                 sessions: 'users/sessions'
  #                               }

  resources :registrations
  resources :sessions
  resources :password
  resources :password_reset

  patch '/id/:id/edit', to: 'registrations#update', as: :edit_user_info

  resources :games

  root to: "application#home", as: :home

  namespace :api do
    namespace :v1 do
      defaults format: :json do
        get 'games', to: 'games#index'
        get 'games/:id', to: 'games#show'
        get 'id/:id', to: 'profiles#show'
      end
    end
  end


  patch '/games/:id/choose_winner', to: 'games#choose_winner', as: :choose_winner
  post '/games/:id', to: 'participants#create', as: :game_participants
  get '/id/:id', to: 'profiles#show', as: :user_profile
  get '/id/:id/friends', to: 'profiles#friends', as: :user_friends
  post '/id/:id', to: 'friendships#create', as: :user_friendships
  patch '/id/:id', to: 'friendships#update', as: :friendship
  delete '/notification/:id', to: 'notifications#destroy', as: :notification_destroy

  post '/games/:id/game_invites', to: 'notifications#create_user_invite', as: :game_invites

  post '/game_invites/:id/accept', to: 'notifications#accept_invite', as: :accept_invite
  delete '/game_invites/:id/decline', to: 'notifications#decline_invite', as: :decline_invite

  post  '/frienships/create', to: 'notifications#send_friendship_request', as: :send_friendship_request
  patch '/friendships/:id/accept', to: 'notifications#accept_friendship', as: :accept_friendship
  patch '/friendships/:id/decline', to: 'notifications#decline_friendship', as: :decline_friendship
end
