class AddPostedByToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :posted_by, :integer
  end
end
