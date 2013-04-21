class PointAction < ActiveRecord::Base
	attr_accessible :user_id,:content,:poll_id,:point,:action_type,:thumbnail

	belongs_to :user

  default_scope :order => 'point_actions.created_at DESC'

	# for create_poll_action, make sure the thumbnail of the first item is still there
  def PointAction.check_thumbnails point_actions 
  	point_actions.each do |pa|
      if pa.action_type == 1
    		poll = Poll.find(pa.poll_id)
    		if poll && !poll.is_deleted 
    			not_deleted = true
    			poll.items.each do |item|
    				thumbnail = item.photo(:thumbnail) if !item.is_deleted
    				not_deleted = !item.is_deleted if item.photo(:thumbnail) == pa.thumbnail
    			end
          pa.update_attributes(:thumbnail => thumbnail) if !not_deleted
    		end
      end
  	end
  end

end
