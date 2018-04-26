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
      auth_response = RestClient.post('https://accounts.spotify.com/api/token', body)
      auth_params = JSON.parse(auth_response.body)
      header = {
        Authorization: "#{auth_params["token_type"]} #{auth_params["access_token"]}"
      }
      user_response = RestClient.get("https://api.spotify.com/v1/me", header)
      user_params = JSON.parse(user_response.body)
      # byebug
      @user = User.find_or_create_by(user_spotify_id: user_params["id"])
      # Add or update user's information here
      img_url = user_params["images"][0] ? user_params["images"][0]["url"] : nil
      @user.update(display_name: user_params["display_name"], profile_img_url: img_url)
      @user.update(access_token:auth_params["access_token"], refresh_token: auth_params["refresh_token"], expiration: auth_params["expires_in"])
      # redirect_to "http://localhost:3001/success"
      token = issue_token({user_id: @user.id})
      render json: {jwt: token, user: {display_name: @user.display_name, user_spotify_id: @user.user_spotify_id}}

    end
  end

end
