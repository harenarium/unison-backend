class Api::V1::PlaylistTracksController < ApplicationController
  def create

    @user = BackendAdapter.get_current_user(params[:jwt])
    header = BackendAdapter.get_header(@user)
    SpotifyAdapter.update_user_tracks(@user)

  end
end
