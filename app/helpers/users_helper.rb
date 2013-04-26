module UsersHelper
	def gravatar_for(user,options = { :size => 50 })
		gravatar_image_tag(user.email.downcase, :alt => user.name,
			                                    :class=> 'gravatar',
			                                    :gravatar => options)
  end

  def settings_path
    "/users/#{current_user.id}/settings"
  end

  def profile_path
    "/users/#{current_user.id}#tab=points/id=#{current_user.id}"
  end
end
