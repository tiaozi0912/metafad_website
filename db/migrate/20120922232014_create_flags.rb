class CreateFlags < ActiveRecord::Migration
  def change
    create_table :flags do |t|
      t.integer :reporter_id
      t.integer :item_id
      t.timestamps
    end
  end
end
