Rails.application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  root to: "questions#index"

  concern :voitingable do
    member do
      post :like
      post :dislike
    end
  end

  resources :questions, concerns: [:voitingable] do
    resources :comments, only: [:create]#, defaults: { context: 'question' }

    resources :answers, shallow: true, concerns: [:voitingable], only: [:create, :update, :destroy] do
      member { post :best }

      resources :comments, only: [:create]#, defaults: { context: 'answer' }
    end
  end

  resources :attach_files, only: [:destroy]
  resources :links, only: [:destroy]
  resources :rewards, only: [:index]
  
end
