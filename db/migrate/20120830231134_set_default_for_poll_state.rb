class SetDefaultForPollState < ActiveRecord::Migration
  def up
  	change_column :polls, :state, :integer, default: 0 
  end

  def down
  	change_column :polls, :state, :integer
  end
end
