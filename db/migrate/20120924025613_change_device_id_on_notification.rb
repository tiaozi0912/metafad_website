class ChangeDeviceIdOnNotification < ActiveRecord::Migration
  def up
  	change_column :apn_notifications, :device_id, :integer, null:true
  	add_column :apn_notifications, :user_id, :integer
  end

  def down
  	change_column :apn_notifications, :device_id, :integer, null:false
  	remove_column :apn_notifications, :user_id
  end
end
