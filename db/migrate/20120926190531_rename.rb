class Rename < ActiveRecord::Migration
  def up
  	rename_column :apn_notifications, :user_id, :action_user_id
  	add_column :apn_notifications,:user_id,:integer
  end

  def down
  	remove_column :apn_notifications,:user_id
  	rename_column :apn_notifications, :action_user_id, :user_id
  	
  end
end
