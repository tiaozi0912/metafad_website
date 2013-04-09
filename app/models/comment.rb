class Comment < ActiveRecord::Base
	belongs_to :item
	belongs_to :commenter, :class_name => "User"

	default_scope :order => 'comments.created_at ASC'
end
