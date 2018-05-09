class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :display_name
      t.string :user_spotify_id
      t.string :access_token
      t.string :refresh_token
      t.string :token_type
      t.string :profile_img_url
      t.integer :expiration
      t.boolean :autoupdate, dafault: false
      t.boolean :include_playlists, default: true
      t.boolean :include_artists, default: true
      t.boolean :include_library, default: true
      t.boolean :include_some_playlists, default: false


      t.timestamps
    end
  end
end
