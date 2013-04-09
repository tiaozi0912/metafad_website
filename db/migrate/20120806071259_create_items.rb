class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :poll_id
      t.string :description
      t.float :price
      t.integer :number_of_votes
      t.string :photo_url

      t.timestamps
    end
  end
end
