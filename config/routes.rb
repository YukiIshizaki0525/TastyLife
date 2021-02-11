Rails.application.routes.draw do
  root 'homes#index'
  get 'recipes/tweet', to: 'homes#tweet_index'
  get 'recipes/tag/:name', to: "recipes#tag_search"
  
  # devise_for :users
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  resources :recipes
  resources :users
  resources :relationships, only: [:create, :destroy]
  

  resources :users do
    member do
      get :following, :followers, :consultations
    end
  end
  
  resources :recipes do
    resources :comments, only: [:create, :destroy]
  end


  # 相談機能についてのルート
  resources :consultations

  resources :consultations do
    resources :consultation_comments
  end
end