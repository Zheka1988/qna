Rails.application.routes.draw do

  devise_for :users
  root to: "questions#index"

  resources :questions do
    resources :answers, shallow: true, only: [:create, :update, :destroy] do
      member { post :best }
    end
  end
  resources :attach_files, only: [:destroy]
  resources :links, only: [:destroy]
  resources :rewards, only: [:index]
end
