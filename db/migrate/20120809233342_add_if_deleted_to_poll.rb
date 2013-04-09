class AddIfDeletedToPoll < ActiveRecord::Migration
  def change
  	 add_column :polls,:poll_is_deleted,:boolean
  end
end
