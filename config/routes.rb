Rails.application.routes.draw do
  devise_for :users
  resources :recipes
  root 'homes#index'
end
