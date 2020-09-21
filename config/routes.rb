Rails.application.routes.draw do
  # devise_for :users
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  resources :users
  resources :recipes
  resources :relationships, only: [:create, :destroy]
  root 'homes#index'

  resources :users do
    member do
      get :following, :followers
    end
  end
end