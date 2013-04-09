class UpdatePoll < ActiveRecord::Migration
  def up 
  	remove_column :polls, :state
  	remove_column :poll_records, :poll_record_type
  	add_column :polls, :state, :integer
  	add_column :polls, :open_time, :string
  	add_column :poll_records, :poll_record_type,:integer
  end

  def down
  	remove_column :polls, :open_time
  	remove_column :polls, :state
  	remove_column :poll_records, :poll_record_type
  	add_column :polls, :state, :string
  	add_column :poll_records, :poll_record_type,:string
  end
end
