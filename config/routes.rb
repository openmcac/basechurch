Basechurch::Engine.routes.draw do
  resources :api_keys, except: [:new, :edit]
  devise_for :users,
             class_name: 'Basechurch::User',
             controllers: { sessions: 'sessions' }

  namespace :v1, defaults: { format: 'json' } do
    resources :groups
    resources :posts

    resources :bulletins do
      member do
        post 'announcements/add/:position', to: 'announcements#create_at'
      end
    end

    resources :announcements do
      patch 'move/:position', to: 'announcements#move'
    end
  end
end
