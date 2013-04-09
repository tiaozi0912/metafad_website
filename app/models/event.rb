class Event < ActiveRecord::Base
  attr_accessible :poll_id, :user_id, :is_deleted, :rank

  belongs_to :user
  belongs_to :poll

  validates :poll_id, :presence => true

  default_scope :order => 'events.created_at DESC'

  
end