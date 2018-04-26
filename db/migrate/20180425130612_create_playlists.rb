class CreatePlaylists < ActiveRecord::Migration[5.1]
  def change
    create_table :playlists do |t|
      t.string :playlist_name
      t.string :playlist_spotify_id
      t.integer :tracks_total
      t.string :tracks_href
      t.boolean :active

      t.timestamps
    end
  end
end
