class PopulateUniqueName < ActiveRecord::Migration
  def change
    Restaurant.all.each do |restaurant|
      restaurant.update unique_name: restaurant.name
    end
  end
end
