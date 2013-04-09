class SetNullTrue < ActiveRecord::Migration
  def change
  	change_column :users, :persistence_token, :string, :null => true

    change_column :users, :single_access_token, :string, :null => true

    change_column :users, :perishable_token, :string, :null => true
  end
end
