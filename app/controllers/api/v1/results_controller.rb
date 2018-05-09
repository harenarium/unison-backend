class Api::V1::ResultsController < ApplicationController
  def create
    # pass in and check connection?
    @user = BackendAdapter.get_current_user(params[:jwt])
    @user2 = User.find_by(user_spotify_id: params[:otherUserId])

    user_tracks = ((@user.include_playlists ? @user.playlist_tracks.map{|x| x.track} : []) +
    (@user.include_some_playlists ? @user.playlists.where(active: true).reduce([]){|tracks,playlist| tracks + playlist.tracks} : []) +
    (@user.include_library ? @user.tracks : [])).uniq

    user2_tracks = ((@user2.include_playlists ? @user2.playlist_tracks.map{|x| x.track} : []) +
    (@user2.include_some_playlists ? @user2.playlists.where(active: true).reduce([]){|tracks,playlist| tracks + playlist.tracks} : []) +
    (@user2.include_library ? @user2.tracks : [])).uniq

    user_tracks_ids = user_tracks.map{|x| x.id}
    tracks_intersection = user2_tracks.select{|x| user_tracks_ids.include? x.id}

    artists_intersection = []
    user_artists_ids = @user.artists.map{|x| x.id}
    user2_artists_ids = @user2.artists.map{|x| x.id}

    if @user.include_artists && @user.include_artists
      # artists_intersection = (user_artists_ids && user2_artists_ids).map or something
      artists_intersection = @user2.artists.select{|x| user_artists_ids.include? x.id}
    end

    artist_track_intersections = []
    if @user.include_artists
      artist_track_intersections += user2_tracks.select{|track| (track.artists.map{|x| x.id} & user_artists_ids).present? }
    end
    if @user2.include_artists
      artist_track_intersections += user_tracks.select{|track| (track.artists.map{|x| x.id} & user2_artists_ids).present? }
    end
    render json: {resulttracks: tracks_intersection, resultmoretracks: artist_track_intersections, resultartists: artists_intersection}
  end
end


# results then actions


# get all active tracks form selected playlists and library
# user.include_playlists ? user.playlists.where(active: true) : []
# then get tracks form each playlist
# user.include_library ? user.tracks : []
#
# and dif
#
# user1.include_artists ? user2slists.where track.artist = artist
# and
# user2.include_artists ? artists == artists
# or only
# user2.include_artists ? user2slists.where track.artist = artist
