class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :attachment_url # share the method with Views
  helper_method :is_consumer?
  include SessionsHelper
  include NotificationsHelper

  def authenticate
    if current_user.nil?
      flash[:error] = "Please log in your Muse Me account."
      store_location
      redirect_to '/signin'
    end
    return !current_user.nil?
  end

  def admin_authenticate
    if current_user.nil?
      flash[:error] = "Please log in your Muse Me account."
      store_location
      cookies.signed[:admin] = true
      redirect_to '/signin'
    end
    return !current_user.nil?
  end
  
  def get_token auth
    token = auth['credentials']['token'];
    cookies.signed[:access_token] = token if cookies.signed[:access_token] != token;
    puts "response from fb #{auth}"
    puts "new token is #{token}"
    puts "old token is #{cookies.signed[:access_token]}"
  end

  def store_location
    cookies.signed[:return_to] = request.url
  end

  def clear_location
    cookies.signed[:return_to] = nil
  end

  def redirect_back_or_default(default)
    #print "url is #{session[:return_to].to_s}"
    redirect_to(cookies.signed[:return_to]||default)
    clear_location
  end
  
  def select_not_deleted obj_arr
    obj_new_arr = obj_arr.where('is_deleted = false')
    return obj_new_arr
  end

  def attachment_url(attachment,style)
    if attachment.url(style.to_sym) =~ /missing/
      url = "/images/default-profile-photo.png"
    else
      url = attachment.url(style.to_sym).gsub(/museme_website/,'museme-server-end')
    end
  end

  def count_unread_notifications user_id
      number_of_unread_notifications = APN::Notification.where(:user_id=>user_id, :is_read=>false).count
      number_of_unread_notifications = number_of_unread_notifications+1
  end

  def send_notifications
    notifications = APN::Notification.where('device_id IS NOT NULL').select{|n| n.sent_at == nil}
    APN::Notification.send_notifications notifications
  end

  def create_audience item_id
    @item_id = item_id.to_i
    @item = Item.find(@item_id)
    @poll = @item.poll 
    @voted_user_ids = @poll.audiences.where('has_voted != 0').map(&:user_id).uniq
    puts "create audience succeed!"
    if @voted_user_ids.include?(current_user.id)
      flash.now['alert-error'.to_sym]="You already voted."
    else
      audience = @item.poll.audiences.find{|audience| audience.user_id == current_user.id} || Audience.create(:poll_id => @poll.id,:user_id => current_user.id)
      #update poll
      @poll.total_votes = @poll.total_votes+1
      @item.number_of_votes = @item.number_of_votes + 1
      @poll.save
      @item.save
      @poll_record_type = 3
      create_poll_record(@item,@poll_record_type)
      #update audience
      audience.is_following = true
      audience.has_voted = @item.id
      audience.save
      generate_voted_notification(@poll.user_id,current_user.id,@item)
      cookies.signed[:item_id] = nil

      (cookies.signed[:item_id].nil?) ? (puts "cookie is clear") : (puts "cookie is not clear!")
      flash[:'alert-success']="Thank you for your vote."
      redirect_to "/polls/#{@poll.id}"
    end
  end

  def create_poll_record(item,type_num)
    PollRecord.create do |poll_record|
      poll_record.poll_id = item.poll.id
      poll_record.user_id = current_user.id
      poll_record.poll_record_type = type_num
    end
  end

  def is_consumer?
    cookies.signed[:page] == "consumers"
  end

end
