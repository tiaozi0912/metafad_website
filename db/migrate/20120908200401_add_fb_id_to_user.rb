class AddFbIdToUser < ActiveRecord::Migration
  def up
  	add_column :users, :fb_id, :integer
  end

  def down
  	remove_column :users, :fb_id
  end
end
