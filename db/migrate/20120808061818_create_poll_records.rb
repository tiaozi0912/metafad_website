class CreatePollRecords < ActiveRecord::Migration
  def change
    create_table :poll_records do |t|
      t.integer :poll_id
      t.string :poll_record_type
      t.integer :user_id

      t.timestamps
    end
  end
end
