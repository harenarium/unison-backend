class Api::V1::SettingsController < ApplicationController
  def create
    @user = BackendAdapter.get_current_user(params[:jwt])

    case params[:value]+params[:checked].to_s

    when "autoupdatetrue"
      User.update(autoupdate: true)
    when "autoupdatefalse"
      User.update(autoupdate: false)
    when "alltrue"
      User.update(include_playlists: true)
    when "allfalse"
      User.update(include_playlists: false)
    when "sometrue"
      User.update(include_some_playlists: true)
    when "somefalse"
      User.update(include_some_playlists: false)
    when "artiststrue"
      User.update(include_artists: true)
    when "artistsfalse"
      User.update(include_artists: false)
    when "librarytrue"
      User.update(include_library: true)
    when "libraryfalse"
      User.update(include_library: false)
    end

    render json: {
      autoupdate: @user.autoupdate,
      playlists: @user.include_playlists,
      some: @user.include_some_playlists,
      artists: @user.include_artists,
      library: @user.include_library,
    }

  end

  def show
    @user = BackendAdapter.get_current_user(params[:jwt])

    render json: {
      autoupdate: @user.autoupdate,
      playlists: @user.include_playlists,
      some: @user.include_some_playlists,
      artists: @user.include_artists,
      library: @user.include_library,
    }
  end
end
