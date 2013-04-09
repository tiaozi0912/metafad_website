class AddAttributesToItems < ActiveRecord::Migration
  def change
  	 add_column :items, :category, :string
  	 add_column :items, :brand, :string
  	 remove_column :audiences, :has_voted
  	 add_column :audiences, :has_voted, :integer, default: 0
  end
end
