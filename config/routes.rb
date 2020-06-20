Rails.application.routes.draw do
  resources :recipes
  devise_for :users
  root 'homes#index'
end
