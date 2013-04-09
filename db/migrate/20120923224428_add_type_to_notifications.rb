class AddTypeToNotifications < ActiveRecord::Migration
  def up
  	add_column :apn_notifications, :type, :integer
  	add_column :apn_notifications, :item_id, :integer
  	add_column :apn_notifications, :follower_id, :integer
  end
  def down
  	remove_column :apn_notifications, :type
  	remove_column :apn_notifications, :item_id
    remove_column :apn_notifications, :follower_id
  end
end
