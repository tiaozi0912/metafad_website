class CorrectTypo < ActiveRecord::Migration
  def change
  	rename_column :polls, :own_id, :owner_id

  end
end
