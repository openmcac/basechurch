Basechurch::Engine.routes.draw do
  resources :api_keys, except: [:new, :edit]
  devise_for :users,
             class_name: 'Basechurch::User',
             controllers: { sessions: 'sessions' }

  namespace :v1, defaults: { format: 'json' } do
    jsonapi_resources :groups
    resources :posts
    resources :bulletins

    resources :announcements do
      member do
        patch 'move/:position', to: 'announcements#move'
      end
    end

    post '/bulletins/:bulletin_id/announcements/add/:position',
        to: 'announcements#create_at'

    get '/sunday', to: 'bulletins#sunday'
  end
end
