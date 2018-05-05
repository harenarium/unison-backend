class Track < ApplicationRecord
  has_many :artist_tracks

  has_many :artists, through: :artist_tracks
  has_many :user_tracks
  has_many :users, through: :user_tracks
  has_many :playlist_tracks
  has_many :playlists, through: :playlist_tracks
end
