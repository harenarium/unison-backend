class BackendAdapter

  def self.get_current_user(jwt)
    user_id = JWT.decode(jwt, ENV["JWT_SECRET"], ENV["JWT_ALGORITHM"])[0]["user_id"]
    User.find(user_id)
  end

  def self.get_header(user)
    header = {Authorization: "#{user["token_type"]} #{user["access_token"]}"}
  end

end
