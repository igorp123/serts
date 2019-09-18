Rails.application.routes.draw do
  root to: 'invoices#index'

  resources :invoices, param: :token

  resources :drugs, param: :token do
    resources :serts

    get :download_zip, on: :member
    get :download_pdf, on: :member
  end
end
