Rails.application.routes.draw do
  root "welcome#index"
  resources :events
  resources :people
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  get "login", to: "sessions#new"
end
