Rails.application.routes.draw do
  root 'homes#index'
  get 'consultation_interests/create'
  get 'consultation_interests/destroy'
  get 'recipes/tweet', to: 'homes#tweet_index'
  get 'recipes/tag/:name', to: "recipes#tag_search"
  get 'recipes/search', to: 'recipes#search'

  get 'users/:id/reregistration', to: 'users#reregistration', as: 'reregistration'
  patch '/users/:id/withdrawal' => 'users#withdrawal', as: 'withdrawal'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }

  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end

  resources :users

  resources :users do
    member do
      get :following, :followers, :consultations, :favorites, :interests, :inventories, :unsubscribe
    end
  end

  resource :user do
    collection do
      get :restoration, to: 'users#restoration'
      post :restore_mail, to: 'users#restore_mail'
    end
  end

  resources :relationships, only: [:create, :destroy]

  resources :recipes
  resources :recipes do
    resources :comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end

  resources :consultations

  resources :consultations do
    resources :consultation_comments, only: [:create, :destroy]
    resource :interests, only: [:create, :destroy]
  end

  resources :inventories, only: [:show, :new, :create, :edit, :update, :destroy]
end