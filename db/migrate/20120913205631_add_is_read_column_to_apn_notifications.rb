class AddIsReadColumnToApnNotifications < ActiveRecord::Migration
  def up
  	add_column :apn_notifications, :is_read, :boolean, default: false
  end
  def down
  	remove_column :apn_notifications, :is_read
  end
end
