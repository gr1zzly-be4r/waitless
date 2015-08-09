Rails.application.routes.draw do
  # Show all of the restaurants at the root index
  get "/", to: "restaurants#index", as: "root"  

  # Static pages routes below 
  get "/about", to: "static_pages#about"
  get "/contact", to: "static_pages#contact"
  get "/help", to: "static_pages#help"
  ########

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  get "/signup", to: "users#new"
  get "/logged_out", to: "static_pages#logged_out"

  resources :comments

  resources :users do
    member do
      get "/settings", to: "users#settings"
      get "/comments", to: "users#comments"
    end
  end
  resources :restaurants do
    member do
      put "upvote", to: "restaurants#upvote"
      put "downvote", to: "restaurants#downvote"
    end
  end
end
