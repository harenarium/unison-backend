class Api::V1::ConnectionsController < ApplicationController
  def create
    user_id = JWT.decode(params[:jwt], ENV["JWT_SECRET"], ENV["JWT_ALGORITHM"])[0]["user_id"]
    @user = User.find(user_id)
    @user2 = User.find_by(user_spotify_id: params[:otheruser])

    # byebug
    @connection = Connection.find_or_create_by(connector_id: @user.id, connectee_id: @user2.id)
    @connection2 = Connection.find_by(connector_id: @user2.id, connectee_id: @user.id)
    if @connection2
      render json: {status: "complete",
        connectionjwt: JWT.encode({connection_id: @connection.id}, ENV["JWT_SECRET"], ENV["JWT_ALGORITHM"])
      }
    else
      render json: {status: "pending"}
    end

  end

  def show

    user_id = JWT.decode(params[:jwt], ENV["JWT_SECRET"], ENV["JWT_ALGORITHM"])[0]["user_id"]
    @user = User.find(user_id)

    @connector_connections = Connection.where(connector_id: @user.id)
    @connectee_connections = Connection.where(connectee_id: @user.id)

    pendees = @connector_connections.map{|x| x.connectee_id}
    @completed_connectee_connections = @connectee_connections.select{|x| pendees.include? x.connector_id}
    completed_connectee_ids = @completed_connectee_connections.map{|x| x.id}
    @requestedconnections = @connectee_connections.reject{|x| completed_connectee_ids.include? x.id}

    requestees = @connectee_connections.map{|x| x.connector_id}
    @completed_connections = @connector_connections.select{|x| requestees.include? x.connectee_id}
    completed_connector_ids = @completed_connector_connections.map{|x| x.id}
    @pendingconnections = @connector_connections.reject{|x| ids.include? x.id}


    render json: {
      connections: @completed_connections,
      pending: @pendingconnections,
      requests: @requestedconnections,
    }


    render json: {playlists: Playlist.where(user_id: user_id)}
  end
end
