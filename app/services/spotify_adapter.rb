class SpotifyAdapter

  def self.update_playlists(user)
    user.playlists.each do |playlist|
      playlist.delete
    end

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
        @playlist = Playlist.find_or_create_by(playlist_spotify_id: playlist["id"], user_id: user.id)
        @playlist.update( playlist_name: playlist["name"], tracks_total: playlist["tracks"]["total"], tracks_href: playlist["tracks"]["href"])
      end
      offset +=50
      total = playlist_params["total"]
    end
  end

  def self.update_playlist_tracks(user)
    user.playlists.each do |playlist|
      # delete all playlisttracks
      PlaylistTrack.where(playlist_id: playlist.id).each do |playlistTrack|
        playlistTrack.delete
      end

      numberofrequests = playlist.tracks_total/50 + (playlist.tracks_total%50>0 ? 1 : 0)
      numberofrequests.times do
        offset=0
        total=100
        while offset <= total
          # sleep(0.5)
          begin
            playlist_response = RestClient.get("#{playlist.tracks_href}?offset=#{offset}&limit=100", header)
          rescue RestClient::ExceptionWithResponse => err
            puts err.response # does this work???
          end
          tracks_params = JSON.parse(playlist_response.body)
          # byebug
          tracks_params["items"].each do |track|
            @track = Track.find_or_create_by(track_spotify_id: track["track"]["id"], track_name: track["track"]["name"])
            track["track"]["artists"].each do |artist|
              @artist = Artist.find_or_create_by(artist_name: artist["name"], artist_spotify_id: artist["id"])
              ArtistTrack.find_or_create_by(artist_id: @artist.id, track_id: @track.id)
            end
            # create playlist-track join relationship thingy
            PlaylistTrack.find_or_create_by(playlist_id: playlist.id, track_id: @track.id)
            # also should delete tracks that now don't exist
          end
          offset +=100
          total = tracks_params["total"]
        end
      end
    end
  end

  def self.update_playlist_settings(user)

  end

  def self.update_user_settings(user)

  end
end
