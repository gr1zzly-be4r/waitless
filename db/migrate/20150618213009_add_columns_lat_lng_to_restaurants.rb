class AddColumnsLatLngToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :lat, :decimal, precision: 8, scale: 3
    add_column :restaurants, :lng, :decimal, precision: 8, scale: 3
  end
end
