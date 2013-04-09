class SetDefaultValueOnNumberOfVotes < ActiveRecord::Migration
  def up
  	 change_column :items, :number_of_votes, :integer, default: 0 	
  end

  def down
  end
end
