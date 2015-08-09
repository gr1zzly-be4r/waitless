class AddForeignKeyToRestaurants < ActiveRecord::Migration
  def change
    add_foreign_key :restaurants, :users
  end
end
