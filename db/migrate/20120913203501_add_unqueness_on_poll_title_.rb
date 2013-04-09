class AddUnquenessOnPollTitle < ActiveRecord::Migration
  def up
  	add_index :polls,:title, :unique => true
  end

  def down
  	remove_index :polls,:title
  end
end
