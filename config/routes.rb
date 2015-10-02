Rails.application.routes.draw do
  devise_for :user, controllers: { sessions: "sessions" }

  devise_scope :user do
    post "api/users/sign_in", to: "sessions#create"
  end

  resources :api_keys, except: [:new, :edit]

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      jsonapi_resources :groups do
        jsonapi_relationships

        get "sign", on: :collection
      end

      jsonapi_resources :bulletins do
        jsonapi_relationships

        get "sign", on: :collection
      end

      jsonapi_resources :users

      jsonapi_resources :announcements do
        jsonapi_relationships
      end

      jsonapi_resources :posts do
        jsonapi_relationships

        get "sign", on: :collection
      end

      get '/sunday', to: 'bulletins#sunday'
    end
  end
end
