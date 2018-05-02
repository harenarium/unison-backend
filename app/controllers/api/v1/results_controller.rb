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
    result = user2_playlist_tracks.select{|x| user_tracks_id.include? x.track_id}

    render json: {result: result}
  end
end
