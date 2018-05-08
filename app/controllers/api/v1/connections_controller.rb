class Api::V1::ConnectionsController < ApplicationController
  def create
    @user = BackendAdapter.get_current_user(params[:jwt])
    @user2 = User.find_by(user_spotify_id: params[:otheruser])

    @connection = Connection.find_or_create_by(connector_id: @user.id, connectee_id: @user2.id)

    if @user.connected_users.include? @user2
      render json: {status: "complete",
        connectionjwt: JWT.encode({connection_id: @connection.id}, ENV["JWT_SECRET"], ENV["JWT_ALGORITHM"])
      }
    else
      render json: {status: "pending"}
    end

  end

  def show
    @user = BackendAdapter.get_current_user(params[:jwt])

    render json: {
      connections: @user.connected_users,
      pending: @user.pending_users,
      requests: @user.requested_users,
    }
  end
end
