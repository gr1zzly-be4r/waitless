class AddColumnShowNameToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :unique_name, :string
  end
end
