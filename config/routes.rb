Rails.application.routes.draw do
  root to: 'invoices#index'

  resources :invoices, only: [:show, :create], param: :token

  resources :drugs, only: [:show, :new, :crerate], param: :token do
    resources :serts, only: [:create]

    get :download, on: :member
  end
end
