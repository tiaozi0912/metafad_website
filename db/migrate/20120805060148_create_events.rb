class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :type
      t.integer :user_id
      t.integer :poll_id
      t.integer :item_id

      t.timestamps
    end
  end
end
