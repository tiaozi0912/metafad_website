class PointAction < ActiveRecord::Base
	attr_accessible :user_id,:content,:poll_id,:point,:action_type,:thumbnail

	belongs_to :user
  belongs_to :poll

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

  def to_json
    poll_url = (poll.nil? ? '/polls/is_deleted' : poll.url)
    json = {
      :point => point,
      :content => content,
      :action_type => action_type,
      :thumbnail => thumbnail,
      :poll_id => poll_id,
      :poll_url => poll_url,
      :user_id => user_id,
      :created_at => created_at.localtime.strftime('%m/%d/%Y %H:%M')
    }
  end

end
