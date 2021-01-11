Rails.application.routes.draw do
  root 'homes#index'
  get 'recipes/tweet', to: 'homes#tweet_index'
  
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
  
  resources :recipes do
    resources :comments, only: [:create, :destroy]
  end

end