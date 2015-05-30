Basechurch::Engine.routes.draw do
  resources :api_keys, except: [:new, :edit]
  devise_for :users,
             class_name: 'Basechurch::User',
             controllers: { sessions: 'sessions' }

  namespace :v1, defaults: { format: 'json' } do
    jsonapi_resources :groups

    jsonapi_resources :bulletins do
      get "sign", on: :collection
    end

    jsonapi_resources :users
    jsonapi_resources :announcements

    jsonapi_resources :posts do
      get "sign", on: :collection
    end

    get '/sunday', to: 'bulletins#sunday'
  end
end
