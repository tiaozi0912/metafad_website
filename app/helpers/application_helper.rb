module ApplicationHelper

  #require 'sessions_helper'
  include NotificationsHelper

  def title 
    base_title = "Ruby On Rails Tutorial Sample App"
    if @title.nil?
      base_title
    else
      "#{base_title}|#{@title}"
    end
  end

end
