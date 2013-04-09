class ChangeCategoryType < ActiveRecord::Migration
  def up
  	remove_column :polls, :category
  	add_column :polls, :category,:integer
  end

  def down
  end
end
