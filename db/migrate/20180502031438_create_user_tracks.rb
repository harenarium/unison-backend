class CreateUserTracks < ActiveRecord::Migration[5.1]
  def change
    create_table :user_tracks do |t|
      t.string :user_id
      t.string :track_id

      t.timestamps
    end
  end
end
