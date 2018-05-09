class Api::V1::UserArtistsController < ApplicationController
  def create

    @user = BackendAdapter.get_current_user(params[:jwt])
    SpotifyAdapter.update_user_artists(@user)

  end
end
