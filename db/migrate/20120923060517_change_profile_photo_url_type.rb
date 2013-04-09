class ChangeProfilePhotoUrlType < ActiveRecord::Migration
  def up
  	remove_column :users,:profile_photo_url
  	add_column :users,:has_profile_photo_url,:boolean, default:false
  end

  def down
  	remove_column :users,:has_profile_photo_url
  end
end
