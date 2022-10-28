Rails.application.routes.draw do  
  scope "(:locale)", locale: /en|ja|km|zh/ do
    root to: "pages#welcome"
    resources :events, param: :number do
      resources :results
      resources :volunteers
    end
    resources :people do
      resources :results, only: :index
      resources :volunteers, only: :index
    end
    resources :banners
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"
    get "login", to: "sessions#new"
    get "course", to: "pages#course"
    get "results", to: "events#show_latest"
  end
end
