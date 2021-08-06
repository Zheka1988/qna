require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user ,lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  root to: "questions#index"

  concern :voitingable do
    member do
      post :like
      post :dislike
    end
  end

  resources :questions, concerns: [:voitingable] do
    resources :comments, only: [:create]

    resources :answers, shallow: true, concerns: [:voitingable], only: [:create, :update, :destroy] do
      member { post :best }

      resources :comments, only: [:create]
    end
  end

  resources :attach_files, only: [:destroy]
  resources :links, only: [:destroy]
  resources :rewards, only: [:index]
  
  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
        get :index, on: :collection
      end
      
      resources :questions, only: [:index, :show, :destroy, :create, :update] do
        resources :answers, only: [:index, :show, :destroy, :create, :update], shallow: true
      end
    end
  end


end
