Basechurch::Engine.routes.draw do
  resources :api_keys, except: [:new, :edit]
  devise_for :users,
             class_name: 'Basechurch::User',
             controllers: { sessions: 'sessions' }

  namespace :v1, defaults: { format: 'json' } do
    resources :groups
    resources :bulletins
    resources :posts

    resources :announcements do
      patch 'move/:position', to: 'announcements#move'
    end

    post '/groups/:group_id/bulletins/:bulletin_id/announcements',
         to: 'announcements#create',
         as: 'bulletin_announcement'

    post '/groups/:group_id/bulletins/:bulletin_id/announcements/:position',
         to: 'announcements#create_at',
         as: 'bulletin_announcement_at_position'
  end
end
