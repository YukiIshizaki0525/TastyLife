Rails.application.routes.draw do
  get 'consultation_interests/create'
  get 'consultation_interests/destroy'
  root 'homes#index'
  get 'recipes/tweet', to: 'homes#tweet_index'
  get 'recipes/tag/:name', to: "recipes#tag_search"

  # letter_opner_webの設定
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  
  # devise_for :users
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }

  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end

  resources :recipes
  resources :users
  resources :relationships, only: [:create, :destroy]
  

  resources :users do
    member do
      get :following, :followers, :consultations, :inventories
    end
  end
  
  resources :recipes do
    resources :comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end
  

  # 相談機能についてのルート
  resources :consultations

  resources :consultations do
    resources :consultation_comments
    resource :interests, only: [:create, :destroy]
  end

  # 食材管理についてのルート
  resources :inventories
end