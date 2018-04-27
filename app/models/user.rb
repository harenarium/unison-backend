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

  validates :username, uniqueness: true
  validates :user_spotify_id, presence: true, uniqueness: true

  def access_token_expired?
    (Time.now - self.updated_at) > (self.expiration - 200)
  end
end
