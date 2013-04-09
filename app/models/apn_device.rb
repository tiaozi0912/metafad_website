class ApnDevice < ActiveRecord::Base
	attr_accessible :token,:user_id,:app_id
	belongs_to :user
	has_many :apn_notifications
end