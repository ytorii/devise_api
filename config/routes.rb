Rails.application.routes.draw do
  resources :players
  devise_for :users, only: []

  namespace :v1, defaults: { format: :json } do
    resource :login, only: [:create], controller: :sessions
    resource :users, only: [:create]
  end
end
