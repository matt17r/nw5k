Rails.application.routes.draw do
  root "pages#welcome"
  resources :events, param: :number do
    resources :results
  end
  resources :people do
    resources :results, only: :index
  end
  get "people/:id/send_welcome_mail", to: "people#send_welcome_mail", as: "welcome_person"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  get "login", to: "sessions#new"
  get "course", to: "pages#course"
  get "results", to: "events#index"
end
