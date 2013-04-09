class AddUserIdToApnDevice < ActiveRecord::Migration
  def up
  	add_column :apn_devices, :user_id, :integer
  	add_index :apn_devices, :user_id
  end
  def down
  	remove_column :apn_devices, :user_id
  	remove_index :apn_devices, :column => :user_id
  end
end
