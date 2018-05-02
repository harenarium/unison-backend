class Api::V1::ResultsController < ApplicationController
  def create
    # pass in and check connection?
    # get user from connection
    user_id = JWT.decode(params[:jwt], ENV["JWT_SECRET"], ENV["JWT_ALGORITHM"])[0]["user_id"]
    @user = User.find(user_id)
    @user2 = User.find_by(user_spotify_id: params[:otheruser])

    user_tracks = @user.playlist_tracks
    user2_tracks = @user2.playlist_tracks

    user_tracks_id = user_tracks.map{|x| x.track_id}
    result = user2_tracks.select{|x| user_tracks_id.include? x.track_id}

    render json: {result: result}
  end
end
