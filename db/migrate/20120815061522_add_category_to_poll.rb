class AddCategoryToPoll < ActiveRecord::Migration
  def change
  	add_column :polls, :category, :string
  	remove_column :items, :category
  end
end
