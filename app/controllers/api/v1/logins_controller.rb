class Api::V1::LoginsController < ApplicationController

  def create
    client_id= ENV["CLIENT_ID"]
    redirect_uri= ENV["REDIRECT_URI"]
    scope="playlist-read-collaborative%20playlist-modify-private%20playlist-read-private%20playlist-modify-public%20user-top-read%20user-follow-read%20user-library-read"
    url = "https://accounts.spotify.com/authorize"
    redirect_to "#{url}?response_type=code&client_id=#{client_id}&scope=#{scope}&redirect_uri=#{redirect_uri}"
  end

end
