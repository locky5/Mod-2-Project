Rails.application.routes.draw do
  resources :subscriptions
  resources :channels
  resources :games
  resources :languages
  root 'static_pages#home'

  resources :users, only: [:index, :create, :edit, :update]
  get '/profile/:id', to: "users#show", as: "profile"
  delete '/profile/:id', to: "users#destroy"
  get '/signup', to: "users#new", as: "signup"
  get '/login', to: "sessions#new", as: "login"
  get '/profile/:id/edit', to: "users#edit", as: "edit"
  get '/about', to: "abouts#show", as: "about"
  patch '/profile/:id', to: "users#update"

  post '/login', to: "sessions#create"
  delete '/logout', to: "sessions#destroy"

  post '/profile/:id', to: "users#buddy"
end
