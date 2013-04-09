class RemoveFollowerIdOnNotifications < ActiveRecord::Migration
  def up
  	remove_column :apn_notifications, :follower_id
  end

  def down
  	add_column :apn_notifications, :follower_id,:integer
  end
end
