Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get '/login', to: 'logins#create'
      post '/access', to: 'users#create'
      get '/find_user', to: 'users#show'
      post '/find_user', to: 'users#show'

      post '/update_playlists', to: 'playlists#create'
      post '/refresh_playlists', to: 'playlists#show'
      post '/update_playlist_tracks', to: 'playlist_tracks#create'
      post '/update_user_artists', to: 'user_artists#create'
      post '/update_user_tracks', to: 'user_tracks#create'
      post '/connect_user', to: 'connections#create'
      post '/user_connections', to: 'connections#show'
      post '/results', to: 'results#create'
      post '/settings', to: 'settings#create'
      post '/get_settings', to: 'settings#show'
    end
  end
end
