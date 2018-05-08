class User < ApplicationRecord

  # connector_relations "names" the Connection join table for accessing through the connector association
  has_many :connector_relations, foreign_key: "connector_id", class_name: "Connection"
  # source: :connector matches with the belong_to :connector identification in the Connection model
  has_many :connectors, through: :connector_relations, source: :connector
  # connectee_connects "names" the Connection join table for accessing through the connectee association
  has_many :connectee_relations, foreign_key: "connectee_id", class_name: "Connection"
  # source: :connectee matches with the belong_to :connectee identification in the Connection model
  has_many :connectees, through: :connectee_relations, source: :connectee

  has_many :playlists
  has_many :playlist_tracks, through: :playlists

  has_many :user_tracks
  has_many :tracks, through: :user_tracks

  has_many :user_artists
  has_many :artists, through: :user_artists


  validates :user_spotify_id, presence: true, uniqueness: true

  def access_token_expired?
    (Time.now - self.updated_at) > (self.expiration - 200)
  end

  def connected_users
    self.connectees.select{|connectee| self.connectors.include? connectee}
  end

  def pending_users
    self.connectees.reject{|connectee| self.connected_users.include? connectee}
  end

  def requested_users
    self.connectors.reject{|connector| self.connected_users.include? connector}
  end

  def included_tracks
  end

  def included_artist
  end


end
