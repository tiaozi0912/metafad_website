class AddPointColToUser < ActiveRecord::Migration
  def up
  	add_column :users,:point,:integer, default:0
  	add_column :users, :number_of_votes,:integer,default:0
  	add_column :polls, :number_of_sharing, :integer, default:0 
  	add_column :polls,:accepted_item_id, :integer
	create_table :shared_polls do |t|
  	  t.integer :user_id
  	  t.integer :poll_id
  	  t.timestamps
    end
  end
  def down
  	remove_column :users, :point
  	remove_column :users, :number_of_votes
  	remove_column :polls, :number_of_sharing
  	remove_column :polls,:accepted_item_id
  	drop_table :shared_polls
  end
end
