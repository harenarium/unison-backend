class Api::V1::ResultsController < ApplicationController
  def create
    # pass in and check connection?
    # byebug
    connection_id = JWT.decode(params[:connection], ENV["JWT_SECRET"], ENV["JWT_ALGORITHM"])[0]["connection_id"]
    @connection = Connection.find(connection_id)
    # get user from connection
    # user_id = JWT.decode(params[:jwt], ENV["JWT_SECRET"], ENV["JWT_ALGORITHM"])[0]["user_id"]
    @user = User.find(@connection.connector_id)
    @user2 = User.find(@connection.connectee_id)

    user_playlist_tracks = @user.playlist_tracks
    user2_playlist_tracks = @user2.playlist_tracks

    user_tracks_id = user_playlist_tracks.map{|x| x.track_id}
    user2_filtered_playlist_tracks = user2_playlist_tracks.select{|x| user_tracks_id.include? x.track_id}

    user2_filtered_tracks_id = user2_filtered_playlist_tracks.map{|x| x.track_id}
    uniq_tracks_id = user2_filtered_tracks_id.uniq

    result = uniq_tracks_id.map{|id| Track.find(id)}
    # byebug
    render json: {result: result}
  end
end


# results then actions


# get all active tracks form selected playlists and library
user.enable_playlists ? user.playlists.where(active: true) : []
then get tracks form each playlist
user.enable_library ? user.tracks : []

and dif

user1.enable_artists ? user2slists.where track.artist = artist
and
user2.enable_artists ? artists == artists
or only
user2.enable_artists ? user2slists.where track.artist = artist
