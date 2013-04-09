class AudienceIsDeleted < ActiveRecord::Migration
  def change 
  	rename_column :audiences, :is_delete, :is_deleted
  end
end
