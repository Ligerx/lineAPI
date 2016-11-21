class CreateRestaurants < ActiveRecord::Migration[5.0]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :description
      t.string :phone
      t.string :picture
      t.string :address
      t.float :latitude
      t.float :longitude
      t.string :time_open
      t.string :time_closed
      t.integer :num_tables

      t.timestamps
    end
  end
end
