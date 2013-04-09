class RemoveUniquenessOnPollTitle < ActiveRecord::Migration
  def up
  	remove_index :polls,:title
  end

  def down
  	add_index :polls,:title
  end
end
