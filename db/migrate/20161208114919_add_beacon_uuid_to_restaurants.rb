class AddBeaconUuidToRestaurants < ActiveRecord::Migration[5.0]
  def change
    add_column :restaurants, :beaconUUID, :string
  end
end
