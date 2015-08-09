class ChangePostedByColumnName < ActiveRecord::Migration
  def change
    rename_column :restaurants, :posted_by, :user_id
  end
end
