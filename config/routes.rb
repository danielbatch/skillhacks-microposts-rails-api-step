Rails.application.routes.draw do
  root "hello#index"

  namespace :api do
    namespace :v1 do
      resources :articles, only: [:index, :create, :update, :destroy]
    end
  end
end
