Rails.application.routes.draw do

  devise_for :users
  root to: "questions#index"

  concern :voitingable do
    member do
      post :like
      post :dislike
    end
  end

  resources :questions, concerns: [:voitingable] do
    resources :answers, shallow: true, concerns: [:voitingable], only: [:create, :update, :destroy] do
      member { post :best }
    end
  end
  resources :attach_files, only: [:destroy]
  resources :links, only: [:destroy]
  resources :rewards, only: [:index]

end
