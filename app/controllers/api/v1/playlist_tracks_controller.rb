class Api::V1::PlaylistTracksController < ApplicationController
  def create

    @user = BackendAdapter.get_current_user(params[:jwt])
    SpotifyAdapter.update_playlists(@user)
    SpotifyAdapter.update_playlist_tracks(@user)

  end
end
