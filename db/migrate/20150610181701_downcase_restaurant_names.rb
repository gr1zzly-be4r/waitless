class DowncaseRestaurantNames < ActiveRecord::Migration
  def change
    Restaurant.all.each do |restaurant|
      restaurant.update name: restaurant.name.downcase
    end
  end
end
