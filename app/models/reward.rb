class Reward < ActiveRecord::Base
	def self.point_rewards
    point_rewards={:publish_poll=>3,:poll_shared=>3,:poll_got_many_votes=>3,:vote_lot=>10,:vote_accepted=>10,:invite_friend=>5,:recommendation => 3, :vote => 1,:pre_sign_up => 500}
	end
end