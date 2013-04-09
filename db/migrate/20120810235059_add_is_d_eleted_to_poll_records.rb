class AddIsDEletedToPollRecords < ActiveRecord::Migration
  def change
  	add_column :poll_records, :is_deleted, :boolean, default: false
  end
end
