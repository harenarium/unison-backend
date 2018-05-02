class Api::V1::UsersController < ApplicationController
  def create
    if params[:error]
      puts "LOGIN ERROR", params
      redirect_to "http://localhost:3001/login/failure"
    else
      body = {
        grant_type: "authorization_code",
        code: params[:code],
        redirect_uri: ENV['REDIRECT_URI'],
        client_id: ENV['CLIENT_ID'],
        client_secret: ENV["CLIENT_SECRET"]
      }
      begin
        auth_response = RestClient.post('https://accounts.spotify.com/api/token', body)
      rescue RestClient::ExceptionWithResponse => err
        puts err.response # does this work???
      end
      auth_params = JSON.parse(auth_response.body)
      header = {
        Authorization: "#{auth_params["token_type"]} #{auth_params["access_token"]}"
      }
      begin
        user_response = RestClient.get("https://api.spotify.com/v1/me", header)
      rescue RestClient::ExceptionWithResponse => err
        puts err.response # does this work???
      end
      user_params = JSON.parse(user_response.body)
      @user = User.find_or_create_by(user_spotify_id: user_params["id"])
      # Add or update user's information here
      img_url = user_params["images"][0] ? user_params["images"][0]["url"] : nil
      @user.update(display_name: user_params["display_name"], profile_img_url: img_url)
      @user.update(access_token:auth_params["access_token"], token_type:auth_params["token_type"], refresh_token: auth_params["refresh_token"], expiration: auth_params["expires_in"])
      # redirect_to "http://localhost:3001/success"
      token = JWT.encode({user_id: @user.id}, ENV["JWT_SECRET"], ENV["JWT_ALGORITHM"])
      render json: {jwt: token, currentUser: {
        display_name: @user.display_name,
        user_spotify_id: @user.user_spotify_id}
      }
      # auto start get library
    end
  end

  def show
    @user = User.find_by(user_spotify_id: params[:q])
    if @user
      @playlists = Playlist.where(user_id: @user.id)
      render json: {otherUser: {
        display_name: @user.display_name,
        user_spotify_id: @user.user_spotify_id},
        otherUserPlaylists: @playlists
      }
    else
      render json: {otherUser: {
        user_spotify_id: nil}
      }
    end
  end

end
