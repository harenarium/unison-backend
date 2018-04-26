class CreateConnections < ActiveRecord::Migration[5.1]
  def change
    create_table :connections do |t|
      t.integer :connector_id
      t.integer :connectee_id

      t.timestamps
    end
  end
end
