class CreateArtistTracks < ActiveRecord::Migration[5.1]
  def change
    create_table :artist_tracks do |t|
      t.string :artist_id
      t.string :track_id

      t.timestamps
    end
  end
end
