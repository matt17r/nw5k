Rails.application.routes.draw do
  root "welcome#index"
  resources :events do
    resources :results
  end
  resources :people do
    resources :results, only: :index
  end
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  get "login", to: "sessions#new"
end
