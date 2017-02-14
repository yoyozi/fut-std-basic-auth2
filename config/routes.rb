Rails.application.routes.draw do

 root :to => "pages#index"

  get "log_out" => "sessions#destroy", :as => "log_out"
  get "log_in" => "sessions#new", :as => "log_in"

  resources :users, only: [:new, :create]
  resources :sessions

  


 # get "/pages/:page" => "pages#show"
 # root "pages#show", page: "home"

end
