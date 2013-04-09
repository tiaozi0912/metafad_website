class Audience < ActiveRecord::Base
  attr_accessible :is_following, :poll_id, :user_id, :has_voted
  belongs_to :poll
end