class CreatePolls < ActiveRecord::Migration
  def change
    create_table :polls do |t|
      t.string :title
      t.integer :own_id
      t.string :state
      t.integer :total_votes
      t.integer :max_votes_for_single_item
      t.string :end_time

      t.timestamps
    end
  end
end
