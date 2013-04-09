class AddFlagToItem < ActiveRecord::Migration
  def up
  	add_column :items, :number_of_flags, :integer, default:0
  	add_column :users, :number_of_flags, :integer, default:0
  end
  def down
  	remove_column :items, :number_of_flags
  	remove_column :users, :number_of_flags
  end
end
