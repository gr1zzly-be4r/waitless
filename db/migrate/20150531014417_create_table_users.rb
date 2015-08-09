class CreateTableUsers < ActiveRecord::Migration
  def change
    create_table :table_users do |t|
      t.string :email
      t.string :password_digest
    end
  end
end
