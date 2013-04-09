class CreateAudiences < ActiveRecord::Migration
  def change
    create_table :audiences do |t|
      t.integer :poll_id
      t.integer :user_id
      t.boolean :has_voted

      t.timestamps
    end
  end
end
