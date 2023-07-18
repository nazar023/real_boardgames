Rails.application.routes.draw do
  # resources :profiles
  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :games do
    resources :participants
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root to: redirect("games")
  get 'profiles/:user_id', to: 'profiles#show', as: :user_profile
  # Defines the root path route ("/")
  # root "articles#index"
end
