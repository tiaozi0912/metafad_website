class RenameCol < ActiveRecord::Migration
  def change
  	rename_column :polls, :owner_id, :user_id

  end
end
