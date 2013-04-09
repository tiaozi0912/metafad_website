class SetDeafaultForIsDeleted < ActiveRecord::Migration
  def change
  	rename_column :polls, :poll_is_deleted, :is_deleted
    rename_column :items, :item_is_deleted, :is_deleted 
    change_column :polls, :is_deleted, :boolean, default: false
    change_column :items, :is_deleted, :boolean, default: false 	
  end
end
