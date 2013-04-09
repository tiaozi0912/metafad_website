class Reward < ActiveRecord::Base
	def self.point_rewards
    point_rewards={:publish_poll=>1,:poll_shared=>3,:poll_got_many_votes=>3,:vote_lot=>2,:vote_accepted=>10,:invite_friend=>2}
	end
end