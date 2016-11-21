class CreateReservations < ActiveRecord::Migration[5.0]
  def change
    create_table :reservations do |t|
      t.integer :party_size
      t.datetime :time_reserved
      t.datetime :time_seated
      t.datetime :time_left
      t.boolean :cancelled
      t.references :restaurant, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
