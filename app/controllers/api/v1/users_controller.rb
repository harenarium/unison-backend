class Api::V1::UsersController < ApplicationController
  def create
    if params[:error]
      puts "LOGIN ERROR", params
      redirect_to "http://localhost:3001/login/failure"
    else
      body = {
        grant_type: "authorization_code",
        code: params[:code],
        redirect_uri: ENV['REDIRECT_URI'],
        client_id: ENV['CLIENT_ID'],
        client_secret: ENV["CLIENT_SECRET"]
      }
      auth_response = RestClient.post('https://accounts.spotify.com/api/token', body)
      auth_params = JSON.parse(auth_response.body)
      header = {
        Authorization: "#{auth_params["token_type"]} #{auth_params["access_token"]}"
      }
      user_response = RestClient.get("https://api.spotify.com/v1/me", header)
      user_params = JSON.parse(user_response.body)
      @user = User.find_or_create_by(user_spotify_id: user_params["id"])
      # Add or update user's information here
      img_url = user_params["images"][0] ? user_params["images"][0]["url"] : nil
      @user.update(display_name: user_params["display_name"], profile_img_url: img_url)
      @user.update(access_token:auth_params["access_token"], refresh_token: auth_params["refresh_token"], expiration: auth_params["expires_in"])
      # redirect_to "http://localhost:3001/success"
      token = JWT.encode({user_id: @user.id}, ENV["JWT_SECRET"], ENV["JWT_ALGORITHM"])
      render json: {jwt: token, user: {
        display_name: @user.display_name,
        user_spotify_id: @user.user_spotify_id}
      }

      # ##### GET/Update PLAYLISTS ##### #
      #get current user
      offset=0
      total=50
      while total == 50
        begin
          playlist_response = RestClient.get("https://api.spotify.com/v1/me/playlists?offset=#{offset}&limit=50", header)
        rescue RestClient::ExceptionWithResponse => err
          puts err.response # does this work???
        end
        playlist_params = JSON.parse(playlist_response.body)
        playlist_params["items"].each do |playlist|
          @playlist = Playlist.find_or_create_by(playlist_spotify_id: playlist["id"], user_id: @user.id)
          @playlist.update( playlist_name: playlist["name"], tracks_total: playlist["tracks"]["total"], tracks_href: playlist["tracks"]["href"])
        end
        offset +=50
        total = playlist_params["total"]
        # sleep(0.5)
      end
      # byebug

      # ##### GET PLAYLISTTRACKS ##### #
      #get user's playlists and for each playlist do the following
      @user.playlists.each do |playlist|
        numberofrequests = playlist.tracks_total/50 + (playlist.tracks_total%50>0 ? 1 : 0)
        numberofrequests.times do
          offset2=0
          total2=100
          while offset2 <= total2
            # sleep(0.5)
            begin
              tracks_params = JSON.parse(RestClient.get("#{playlist.tracks_href}?offset=#{offset2}&limit=100", header).body)
            rescue RestClient::ExceptionWithResponse => err
              puts err.response # does this work???
            end
            tracks_params["items"].each do |track|
              @track = Track.find_or_create_by(track_spotify_id: track["track"]["id"], track_name: track["track"]["name"])
              @track.update(artist_name: track["track"]["artists"][0]["name"], artist_spotify_id: track["track"]["artists"][0]["id"])
              # create playlist-track join relationship thingy
              PlaylistTrack.find_or_create_by(playlist_id: playlist.id, track_id: @track.id)
              # also should delete tracks that now don't exist
            end
            offset2 +=100
            total2 = tracks_params["total"]
          end
        end
      end


    end
  end

end
