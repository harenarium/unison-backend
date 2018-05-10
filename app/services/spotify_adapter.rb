class SpotifyAdapter

  # def self.update_playlists(user)
  #   header = BackendAdapter.get_header(user)
  #
  #   user.playlists.each do |playlist|
  #     playlist.delete
  #   end
  #
  #   offset=0
  #   total=50
  #   while total == 50
  #     begin
  #       playlist_response = RestClient.get("https://api.spotify.com/v1/me/playlists?offset=#{offset}&limit=50", header)
  #     rescue RestClient::ExceptionWithResponse => err
  #       puts err.response # does this work???
  #     end
  #     playlist_params = JSON.parse(playlist_response.body)
  #     playlist_params["items"].each do |playlist|
  #       @playlist = Playlist.find_or_create_by(playlist_spotify_id: playlist["id"], user_id: user.id)
  #       @playlist.update( playlist_name: playlist["name"], tracks_total: playlist["tracks"]["total"], tracks_href: playlist["tracks"]["href"])
  #     end
  #     offset +=50
  #     total = playlist_params["total"]
  #   end
  # end

  def self.update_playlists_and_playlist_tracks(user)
    header = BackendAdapter.get_header(user)

    user.playlists.each do |playlist|
      playlist.playlist_tracks.each do |playlistTrack|
        playlistTrack.delete
      end
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


        numberofrequests = @playlist.tracks_total/50 + (@playlist.tracks_total%50>0 ? 1 : 0)
        numberofrequests.times do
          inneroffset=0
          innertotal=100
          while inneroffset <= innertotal
            # sleep(0.5)
            begin
              playlist_response = RestClient.get("#{@playlist.tracks_href}?offset=#{inneroffset}&limit=100", header)
            rescue RestClient::ExceptionWithResponse => err
              puts err.response # does this work???
            end
            tracks_params = JSON.parse(playlist_response.body)

            tracks_params["items"].each do |track|
              @track = Track.find_or_create_by(track_spotify_id: track["track"]["id"], track_name: track["track"]["name"], artist_name_string: track["track"]["album"]["name"], album_name: track["track"]["artists"].map{|artist| artist["name"]}.join(", "))
              # playlist.id gives different id for some reason!!!! ????
              # @playlist = Playlist.find_by(playlist_spotify_id: playlist.playlist_spotify_id)
              @pt = PlaylistTrack.find_or_create_by(playlist_id: @playlist.id, track_id: @track.id)
              track["track"]["artists"].each do |artist|
                @artist = Artist.find_or_create_by(artist_name: artist["name"], artist_spotify_id: artist["id"])
                @at = ArtistTrack.find_or_create_by(artist_id: @artist.id, track_id: @track.id)
              end
            end
            inneroffset +=100
            innertotal = tracks_params["total"]
          end
        end

      end
      offset +=50
      total = playlist_params["total"]
    end
  end

  # def self.update_playlist_tracks(user)
  #   header = BackendAdapter.get_header(user)
  #
  #   user.playlists.each do |playlist|
  #     playlist.playlist_tracks.each do |playlistTrack|
  #       playlistTrack.delete
  #     end
  #
  #     numberofrequests = playlist.tracks_total/50 + (playlist.tracks_total%50>0 ? 1 : 0)
  #     numberofrequests.times do
  #       offset=0
  #       total=100
  #       while offset <= total
  #         # sleep(0.5)
  #         begin
  #           playlist_response = RestClient.get("#{playlist.tracks_href}?offset=#{offset}&limit=100", header)
  #         rescue RestClient::ExceptionWithResponse => err
  #           puts err.response # does this work???
  #         end
  #         tracks_params = JSON.parse(playlist_response.body)
  #
  #         tracks_params["items"].each do |track|
  #           @track = Track.find_or_create_by(track_spotify_id: track["track"]["id"], track_name: track["track"]["name"])
  #           # playlist.id gives different id for some reason!!!! ????
  #           # @playlist = Playlist.find_by(playlist_spotify_id: playlist.playlist_spotify_id)
  #           @pt = PlaylistTrack.find_or_create_by(playlist_id: playlist.id, track_id: @track.id)
  #           track["track"]["artists"].each do |artist|
  #             @artist = Artist.find_or_create_by(artist_name: artist["name"], artist_spotify_id: artist["id"])
  #             @at = ArtistTrack.find_or_create_by(artist_id: @artist.id, track_id: @track.id)
  #           end
  #         end
  #         offset +=100
  #         total = tracks_params["total"]
  #       end
  #     end
  #   end
  # end

  def self.update_user_artists(user)
    header = BackendAdapter.get_header(user)

    user.user_artists.each do |ua|
      ua.delete
    end

    # pull all artist
    after=nil
    offset=0
    total=50
    while offset <= total
      begin
        artist_response = RestClient.get("https://api.spotify.com/v1/me/following?type=artist#{after ? `&after=#{after}` : ""}&limit=50", header)
      rescue RestClient::ExceptionWithResponse => err
        puts err.response # does this work???
      end
      artist_params = JSON.parse(artist_response.body)
      artist_params["artists"]["items"].each do |artist|
        @artist = Artist.find_or_create_by(artist_spotify_id: artist["id"], artist_name: artist["name"])
        @ua = UserArtist.find_or_create_by(artist_id: @artist.id, user_id: user.id)
      end
      offset +=50
      total = artist_params["artists"]["total"]
      after = artist_params["artists"]["next"]
      # sleep(0.5)
    end
  end


  def self.update_user_tracks(user)
    header = BackendAdapter.get_header(user)

    user.user_tracks.each do |ut|
      ut.delete
    end

    # pull all tracks
    offset=0
    total=50
    while offset <= total
      begin
        track_response = RestClient.get("https://api.spotify.com/v1/me/tracks?offset=#{offset}&limit=50", header)
      rescue RestClient::ExceptionWithResponse => err
        puts err.response # does this work???
      end
      track_params = JSON.parse(track_response.body)
      track_params["items"].each do |track|
        @track = Track.find_or_create_by(track_spotify_id: track["track"]["id"], track_name: track["track"]["name"], album_name: track["track"]["album"]["name"], artist_name_string: track["track"]["artists"].map{|artist| artist["name"]}.join(", "))
        @ut = UserTrack.find_or_create_by(track_id: @track.id, user_id: user.id)
        track["track"]["artists"].each do |artist|
          @artist = Artist.find_or_create_by(artist_name: artist["name"], artist_spotify_id: artist["id"])
          @at = ArtistTrack.find_or_create_by(artist_id: @artist.id, track_id: @track.id)
        end


      end
      offset +=50
      total = track_params["total"]
      # sleep(0.5)
    end
  end


  def self.update_playlist_settings(user)

  end

  def self.update_user_settings(user)

  end
end
