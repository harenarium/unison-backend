class Artist < ApplicationRecord
  has_many :user_artists
  has_many :users, through: :user_artists
  has_many :artist_tracks
  has_many :tracks, through: :artist_tracks
end
