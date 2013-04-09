class AddAttachmentPhotoToItems < ActiveRecord::Migration
  def self.up
    change_table :items do |t|
      t.has_attached_file :photo
    end
  end

  def self.down
    drop_attached_file :items, :photo
  end
end
