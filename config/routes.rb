Rails.application.routes.draw do

  
  # devise_for :users
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  resources :recipes
  resources :users
  resources :relationships, only: [:create, :destroy]
  

  resources :users do
    member do
      get :following, :followers
    end
  end
  
  root 'homes#index'
  
end