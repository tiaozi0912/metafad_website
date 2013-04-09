class PollRecord < ActiveRecord::Base
	attr_accessible :poll_id, :user_id, :poll_record_type, :is_deleted

	belongs_to :user
	belongs_to :poll

	default_scope :order => 'poll_records.created_at DESC'
end
