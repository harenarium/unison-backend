Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get '/login', to: 'logins#create'
      post '/access', to: 'users#create'
      post '/update_playlists', to: 'playlists#create'
      # change to post^ n
      post '/update_playlist_tracks', to: 'playlisttrackss#create'
      get '/find_user', to: 'users#show'
      post '/connect_user', to: 'connections#create'
      post '/user_connections', to: 'connections#show'
      post '/results', to: 'results#create'
    end
  end
end
