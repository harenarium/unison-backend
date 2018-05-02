class CreateUserArtists < ActiveRecord::Migration[5.1]
  def change
    create_table :user_artists do |t|
      t.string :user_id
      t.string :artist_id

      t.timestamps
    end
  end
end
