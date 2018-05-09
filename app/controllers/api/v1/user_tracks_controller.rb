class Api::V1::UserTracksController < ApplicationController
  def create

    @user = BackendAdapter.get_current_user(params[:jwt])
    SpotifyAdapter.update_user_tracks(@user)

  end
end
