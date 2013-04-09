class ApnNotification < ActiveRecord::Base
	attr_accessible :is_read
	default_scope :order => 'apn_notifications.created_at DESC'

	belongs_to :user
	belongs_to :apn_device
end