Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  resources :users
  resources :recipes
  root 'homes#index'
end