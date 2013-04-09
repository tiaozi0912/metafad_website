class SetPollTotalVotesDefault < ActiveRecord::Migration
  def up
  	change_column :polls, :total_votes, :integer, default: 0 	
  end

  def down
  end
end
