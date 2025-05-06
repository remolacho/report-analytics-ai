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
      end

      namespace :core do
        resources :convert, only: [] do
          collection do
            post 'xlsx_to_dataset', to: 'convert#index'
          end
        end

        resources :chat, only: [:create] do
          delete ':session_id', to: 'chat#destroy', on: :collection
        end
      end
    end
  end
end
