class AddAttriubutesToUser < ActiveRecord::Migration
  def up
  	add_column :users,:last_name,:string
  	add_column :users,:first_name,:string
  end
  def down
  	remove_column :users,:last_name,:string
  	remove_column :users,:first_name,:string
  end
end
