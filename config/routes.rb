Rails.application.routes.draw do
  get 'home/index'
  devise_for :users
  root 'home#index'
  resources :contacts do
    member do
      post :send_document
    end
  end
  resources :email_lists do
    member do
      post :send_document
    end
  end
end
