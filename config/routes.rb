Rails.application.routes.draw do
  root to: 'invoices#index'

  resources :invoices, param: :token
end
