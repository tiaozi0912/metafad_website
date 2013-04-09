class AddRewardsTracker < ActiveRecord::Migration
  def up
  	add_column :users, :votes_rewards_tracker, :integer, default:0
  	add_column :polls, :poll_rewards_tracker, :integer, default:0
  end

  def down
  	remove_column :users, :votes_rewards_tracker
  	remove_column :polls, :poll_rewards_tracker
  end
end
