class CreateTracks < ActiveRecord::Migration[5.1]
  def change
    create_table :tracks do |t|
      t.string :track_name
      t.string :track_spotify_id

      t.timestamps
    end
  end
end
