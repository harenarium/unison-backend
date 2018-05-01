class Api::V1::PlaylistsController < ApplicationController
  def create

    # ##### GET/Update PLAYLISTS ##### #
    #get current user
    user_id = JWT.decode(params[:jwt], ENV["JWT_SECRET"], ENV["JWT_ALGORITHM"])[0]["user_id"]
    @user = User.find(user_id)
    header = {
      Authorization: "#{@user["token_type"]} #{@user["access_token"]}"
    }
    # delete all playlists
    Playlist.where(user_id: user_id).each do |playlist|
      playlist.delete
    end
    # pull all playlists
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

    render json: {playlists: Playlist.where(user_id: user_id)}
  end
end
