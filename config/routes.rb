Rails.application.routes.draw do

  resources :posts
  resources :sessions, only: [:new, :create]

  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  resources :users

  root 'pages#index'

end
