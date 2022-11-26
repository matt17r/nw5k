Rails.application.routes.draw do
  scope "(:locale)", locale: /en|ja|km|zh/ do
    root to: "pages#welcome"
    resources :events, param: :number do
      resources :results
      resources :volunteers
    end
    resources :people
    resources :banners
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"
    get "login", to: "sessions#new"
    get "course", to: "pages#course"
    get "results", to: "events#show_latest"
    get 'events/:number/image', to: 'events#image', defaults: { format: 'svg' }
  end
end
