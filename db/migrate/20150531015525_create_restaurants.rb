class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string :name
      t.decimal :wait, precision: 5, scale: 2

      t.timestamps null: false
    end
  end
end
