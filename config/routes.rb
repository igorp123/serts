Rails.application.routes.draw do
  root to: 'invoices#index'

  resources :invoices, param: :token

  resources :drugs do
    resources :serts
  end
end





# resources :events do
#   resources :comments, only: [:create, :destroy]
#   resources :subscriptions, only: [:create, :destroy]
#   # Вложенные в ресурс события ресурсы фотографий
#   resources :photos, only: [:create, :destroy]
# end
