class AddColumnsLikesDislikesToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :likes, :integer
    add_column :restaurants, :dislikes, :integer
  end
end
