class RenameIsDeletedInAudiences < ActiveRecord::Migration
  def change
  	rename_column :audiences, :is_deleted, :is_following
  end
end
