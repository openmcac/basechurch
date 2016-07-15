Rails.application.routes.draw do
  mount_devise_token_auth_for "User", at: "api/auth", controllers: {
    passwords: "passwords",
    registrations: "registrations",
    sessions: "sessions"
  }

  resources :api_keys, except: [:new, :edit]

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do

      jsonapi_resources :groups do
        jsonapi_relationships

        get "sign", on: :collection
      end

      jsonapi_resources :sermons do
        jsonapi_relationships

        get "sign", on: :collection
      end

      jsonapi_resources :bulletins do
        jsonapi_relationships

        get "sign", on: :collection
        get "next", on: :member
        get "previous", on: :member
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

  get "/(*path)" => "landing#index", as: :root, format: :html
end
