class RenameTypeOnNotifications < ActiveRecord::Migration
  def up
  	rename_column :apn_notifications, :type, :notification_type
  end

  def down
  	rename_column :apn_notifications, :type, :notification_type
  end
end
