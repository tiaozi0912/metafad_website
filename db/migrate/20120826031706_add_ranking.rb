class AddRanking < ActiveRecord::Migration
  def up
  	add_column :events, :rank, :float, default: 0
  end

  def down
    remove_column :events,:rank
  end
end
