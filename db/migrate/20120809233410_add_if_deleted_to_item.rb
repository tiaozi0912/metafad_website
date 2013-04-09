class AddIfDeletedToItem < ActiveRecord::Migration
  def change
  	add_column :items,:item_is_deleted,:boolean
  end
end
