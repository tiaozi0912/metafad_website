class AddIsDeleteToAudiences < ActiveRecord::Migration
  def change
  	add_column :audiences, :is_delete, :boolean, default: false
  end
end
