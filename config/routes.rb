Rails.application.routes.draw do
  root to: 'invoices#index'

  resources :invoices, param: :token

  resources :drugs, param: :token do
    resources :serts

    get :download, on: :member
  end
end
