Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :health, only: [:index]
  namespace :api, path: "" do
    namespace :v1 do
      namespace :chats do
        resources :list, only: [:index]
        resources :create, only: [:create]
        resources :destroy, only: [:destroy]
        resources :show, only: [:show]
      end

      namespace :chat_messages do
        resources :create, only: [:create]
      end
    end
  end
end
