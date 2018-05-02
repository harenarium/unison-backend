class Api::V1::PlaylistTracksController < ApplicationController
  def create
    # ##### GET/Update PLAYLISTS ##### #
    #get current user
    user_id = JWT.decode(params[:jwt], ENV["JWT_SECRET"], ENV["JWT_ALGORITHM"])[0]["user_id"]
    @user = User.find(user_id)
    header = {
      Authorization: "#{@user["token_type"]} #{@user["access_token"]}"
    }

    # ##### GET PLAYLISTTRACKS ##### #
    #get user's playlists OR FROM PARAMS???
    @user.playlists.each do |playlist|
      # delete all playlisttracks
      PlaylistTrack.where(playlist_id: playlist.id).each do |playlistTrack|
        playlistTrack.delete
      end

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

    render json: {}
  end
end
