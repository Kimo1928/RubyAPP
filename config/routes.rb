Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "/register", to: "users#create"
      post "/login",    to: "sessions#create"

      resources :posts do
        resources :comments, only: [:create, :update, :destroy]
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
