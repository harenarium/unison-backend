class Api::V1::PlaylistsController < ApplicationController
  def create
    @user = BackendAdapter.get_current_user(params[:jwt])
    # SpotifyAdapter.update_playlists(@user)
    # probably shouldn't update playlist w/o updating playlist tracks
    # render json: {playlists: @user.playlists}
  end

  def show
    @user = BackendAdapter.get_current_user(params[:jwt])
    render json: {playlists: @user.playlists}
  end
end
