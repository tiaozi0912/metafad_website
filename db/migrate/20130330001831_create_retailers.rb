class CreateRetailers < ActiveRecord::Migration
  def up
    create_table :retailers do |t|
      t.string :name
      t.string :website
      t.string :email

      t.timestamps
    end
  end
  def down
  	drop_table :retailers
  end
end
