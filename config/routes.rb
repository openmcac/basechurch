Rails.application.routes.draw do
  resources :api_keys, except: [:new, :edit]
  devise_for :users, controllers: { sessions: "sessions" }

  namespace :v1, defaults: { format: 'json' } do
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
