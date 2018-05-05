class ArtistTrack < ApplicationRecord
  belongs_to :artist
  belongs_to :track
end
