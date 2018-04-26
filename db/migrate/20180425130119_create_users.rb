class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.integer :connector
      t.integer :conenctee
      t.string :username
      t.string :access_token
      t.string :refresh_token
      t.string :profile_img_url
      t.datetime :expiration

      t.timestamps
    end
  end
end
