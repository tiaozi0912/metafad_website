module NotificationsHelper
 def generate_voted_notification(poll_owner_id, voter_id,item)
    poll_id = item.poll_id
    voter_name = User.find_by_id(voter_id).user_name
    poll_owner_name = User.find_by_id(poll_owner_id).user_name
    poll_title = Poll.find_by_id(poll_id).title
    #could be many device for one user
    devices = User.find_by_id(poll_owner_id).apn_devices
    if poll_owner_id != current_user.id
      if devices.empty?
        notification = APN::Notification.new   
        notification.device = nil  
        notification.badge = count_unread_notifications poll_owner_id
        notification.sound = true
        notification.item_id = item.id
        notification.alert = voter_name + " voted on your poll:" + poll_title
        notification.notification_type = 1002
        notification.action_user_id = current_user.id
        notification.user_id = poll_owner_id
        notification.save
      else   
        devices.each do |device|
          notification = APN::Notification.new   
          notification.device_id = device.id   
          notification.badge = count_unread_notifications poll_owner_id
          notification.sound = true
          notification.item_id = item.id
          notification.alert = voter_name + " voted on your poll:" + poll_title
          notification.notification_type = 1002
          notification.action_user_id = current_user.id
          notification.user_id = poll_owner_id
          notification.save
        end
        send_notifications
      end
    end
  end

  def generate_poll_shared_notification shared_poll
    poll_owner = shared_poll.poll.user
    poll_title = shared_poll.poll.title
    #could be many device for one user
    devices = poll_owner.apn_devices
    if poll_owner != current_user
      if devices.empty?
        notification = APN::Notification.new   
        notification.device = nil  
        notification.badge = count_unread_notifications poll_owner.id
        notification.sound = true
        notification.alert = current_user.user_name + " shared your poll:" + poll_title
        notification.notification_type = 1005
        notification.action_user_id = current_user.id
        notification.user_id = poll_owner.id
        notification.save
      else   
        devices.each do |device|
          notification = APN::Notification.new   
          notification.device_id = device.id   
          notification.badge = count_unread_notifications poll_owner.id
          notification.sound = true
          notification.alert = current_user.user_name + " shared your poll:" + poll_title
          notification.notification_type = 1005
          notification.action_user_id = current_user.id
          notification.user_id = poll_owner.id
          notification.save
        end
        send_notifications
      end
    end
  end

  def generate_vote_accepted_notification(user,poll)
    devices = user.apn_devices
    if devices.empty?
      notification = APN::Notification.new   
      notification.device = nil  
      notification.badge = count_unread_notifications user.id
      notification.sound = true
      notification.alert = "Your vote on poll:" + poll.title + " is accepted by " + poll.user.user_name+ " !"
      notification.notification_type = 1006
      notification.action_user_id = current_user.id
      notification.user_id = user.id
      notification.save
    else   
      devices.each do |device|
        notification = APN::Notification.new   
        notification.device_id = device.id   
        notification.badge = count_unread_notifications user.id
        notification.sound = true
        notification.alert = "Your vote on poll:" + poll.title + " is accepted by " + poll.user.user_name+" !"
        notification.notification_type = 1006
        notification.action_user_id = current_user.id
        notification.user_id = user.id
        notification.save
      end
      send_notifications
    end
  end

  def generate_followed_notification followed_user_id
    following_user_name = current_user.user_name
    devices = User.find_by_id(followed_user_id).apn_devices
    if followed_user_id != current_user.id
      if devices.empty?
        notification = APN::Notification.new   
        notification.device = nil  
        notification.badge = count_unread_notifications followed_user_id
        notification.sound = true
        notification.alert =following_user_name + " is following you now!"
        notification.notification_type = 1001
        notification.action_user_id = current_user.id
        notification.user_id = followed_user_id
        notification.save
      else
        devices.each do |device|
          notification = APN::Notification.new   
          notification.device_id = device.id   
          notification.badge = count_unread_notifications followed_user_id
          notification.sound = true
          notification.alert =following_user_name + " is following you now!"
          notification.notification_type = 1001
          notification.action_user_id = current_user.id
          notification.user_id = followed_user_id
          notification.save
        end
        send_notifications
      end
    end
  end

  def generate_comment_notification item
    comment_users = fetch_all_comment_users item
    poll = item.poll
    item_owner_id = poll.user_id
    commenter_name = current_user.user_name
    comment_users.each do |comment_user|
      if comment_user.apn_devices.empty?
        notification = APN::Notification.new   
        notification.device = nil  
        notification.badge = count_unread_notifications item_owner_id
        notification.sound = true
        notification.alert = commenter_name + " commented on the poll:" + poll.title
        notification.item_id = item.id
        notification.notification_type = 1003
        notification.action_user_id = current_user.id
        notification.user_id = comment_user.id
        notification.save
      else
        comment_user.apn_devices.each do |device|
          notification = APN::Notification.new   
          notification.device_id = device.id   
          notification.badge = count_unread_notifications item_owner_id
          notification.sound = true
          notification.alert = commenter_name + " commented on the poll:" + poll.title
          notification.item_id = item.id
          notification.notification_type = 1003
          notification.action_user_id = current_user.id
          notification.user_id = comment_user.id
          notification.save
        end
      end
    end
    send_notifications
  end

  def fetch_all_comment_users item
    comments = item.comments
    comment_users = User.where('id IN (?) AND id != ? AND id != ?',comments.map(&:commenter_id).uniq,current_user.id,item.poll.user.id)
    #puts comment_users.map{|user| user.user_name} if !comment_users.empty?
    #always include the poll owner 
    if current_user != item.poll.user
      comment_users<<item.poll.user 
    else 
      comment_users
    end
  end

  def generate_poll_deleted_notification item
    poll= item.poll
    item_owner_id = poll.user_id
    devices = User.find_by_id(item_owner_id).apn_devices
    if devices.empty?
      notification = APN::Notification.new   
      notification.device = nil  
      notification.badge = count_unread_notifications item_owner_id
      notification.sound = true
      notification.alert = "One of your polls is deleted by Muse Me administrator becasue it contains inappropriate content. Your account will be blocked if it happens again."
      notification.item_id = item.id
      notification.notification_type = 1004
      notification.user_id = item_owner_id
      notification.save
    else
      devices.each do |device|   
        notification = APN::Notification.new   
        notification.device_id = device.id   
        notification.badge = count_unread_notifications item_owner_id
        notification.sound = true
        notification.alert = "One of your polls is deleted by Muse Me administrator becasue it contains inappropriate content. Your account will be blocked if it happens again."
        notification.item_id = item.id
        notification.notification_type = 1004
        notification.user_id = item_owner_id
        notification.save
      end
      send_notifications
    end
  end

  def generate_tagged_notification(users_id,poll_id)
    poll=Poll.find(poll_id)
    users_id.each do |id|
      user = User.find(id)
      devices = user.apn_devices
      if devices.empty?
        notification = APN::Notification.new   
        notification.device = nil  
        notification.badge = count_unread_notifications user.id
        notification.sound = true
        notification.alert = current_user.user_name +  " invited you to vote the poll:" +poll.title
        notification.item_id = poll.items[0].id
        notification.notification_type = 1007
        notification.action_user_id = current_user.id
        notification.user_id = user.id
        notification.save
      else   
        devices.each do |device|
          notification = APN::Notification.new   
          notification.device_id = device.id   
          notification.badge = count_unread_notifications user.id
          notification.sound = true
          notification.alert = current_user.user_name + " invited you to vote the poll:" + poll.title
          notification.item_id = poll.items[0].id
          notification.notification_type = 1007
          notification.action_user_id = current_user.id
          notification.user_id = user.id
          notification.save
        end
      end
      send_notifications
    end
  end

  def generate_publish_poll_notification poll
    # push notification to the people who follow the user
    users = current_user.followers
    users.each do |user|
      devices = user.apn_devices
      if devices.empty?
        notification = APN::Notification.new   
        notification.device = nil  
        notification.badge = count_unread_notifications user.id
        notification.sound = true
        notification.alert = current_user.user_name +  " published new poll:" +poll.title
        notification.item_id = poll.items[0].id
        notification.notification_type = 1008
        notification.action_user_id = current_user.id
        notification.user_id = user.id
        notification.save
      else   
        devices.each do |device|
          notification = APN::Notification.new   
          notification.device_id = device.id   
          notification.badge = count_unread_notifications user.id
          notification.sound = true
          notification.alert = current_user.user_name + " published new poll:" + poll.title
          notification.item_id = poll.items[0].id
          notification.notification_type = 1008
          notification.action_user_id = current_user.id
          notification.user_id = user.id
          notification.save
        end
      end
      send_notifications
    end
  end

end
