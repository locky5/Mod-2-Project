Rails.application.routes.draw do
  resources :subscriptions
  resources :channels
  resources :games

  resources :users, only: [:index, :create, :destroy]
  get '/profile', to: "users#show", as: "profile"
  get '/signup', to: "users#new", as: "signup"
  get '/login', to: "sessions#new", as: "login"
  post '/login', to: "sessions#create"
  delete '/logout', to: "sessions#destroy"
end
