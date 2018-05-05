class Api::V1::PlaylistsController < ApplicationController
  def create

    @user = BackendAdapter.get_current_user(params[:jwt])
    header = BackendAdapter.get_header(@user)
    SpotifyAdapter.update_playlists(@user)

    render json: {playlists: @user.playlist}
  end
end
