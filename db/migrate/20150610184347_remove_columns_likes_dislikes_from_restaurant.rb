class RemoveColumnsLikesDislikesFromRestaurant < ActiveRecord::Migration
  def change
    remove_columns :restaurants, :likes, :dislikes
  end
end
