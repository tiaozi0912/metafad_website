class AddIndexOnEmail < ActiveRecord::Migration
  def up
  	add_index :users,:email, :unique => true
    remove_index :users, :column => :user_name
    add_index :users, :user_name, :unique => false
  end

  def down
  	remove_index :users, :column => :user_name
  	remove_index :users, :column => :email
  end
end
