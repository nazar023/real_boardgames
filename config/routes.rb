Rails.application.routes.draw do
  devise_for :users
  resources :games do
    resources :participants
  end

    # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root to: redirect("games")
  # Defines the root path route ("/")
  # root "articles#index"
end
