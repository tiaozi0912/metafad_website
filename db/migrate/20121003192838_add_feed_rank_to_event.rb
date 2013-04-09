class AddFeedRankToEvent < ActiveRecord::Migration
  def up
  	add_column :events, :feed_rank, :float
  end
  def down
  	remove_column :events, :feed_rank
  end
end
