class PollsController < ApplicationController
	#before_filter :authenticate
	def show
    store_location
    @poll=Poll.where("is_deleted = false AND id = #{params[:id]}")[0]
    if @poll.nil?
      flash.now['alert-error'.to_sym]="The poll doesn't exist."
    elsif @poll.state != 1 && current_user != @poll.user
      flash.now['alert-error'.to_sym]="The poll hasn't been published yet."
    else
      @title = @poll.user.user_name + "'s poll"
      @items= select_not_deleted @poll.items
      @items_photo_urls = items_photo_urls @items
      @voted_user_ids = @poll.audiences.where('has_voted != 0').map(&:user_id).uniq
      @voted_users = User.where('id IN (?)',@voted_user_ids)
      @voted_user_names = @voted_users.map(&:user_name)
      @num_items_each_row=4
      @if_current_user_voted = false
      @is_poll_owner = false
      @poll_vote_url = '/voted_choice'
      if current_user.nil?
        @current_user_name = "null"
      else 
        @current_user_name = current_user.user_name
        @if_current_user_voted = @voted_users.include?(current_user)
        @is_poll_owner = (current_user == @poll.user)
        check_item_id_in_cookies
      end
      if @items.size/@num_items_each_row == @items.size.to_f/@num_items_each_row.to_f
        @num_rows = @items.size/@num_items_each_row
      else
        @num_rows = @items.size/@num_items_each_row +1
      end
    end
  end 

  # POST /polls
  def new
    if authenticate
      @poll = Poll.new
      respond_to do |format|
        format.html
      end
    end
  end

  def create
    @poll = Poll.find_by_web_id(params[:poll][:web_id])
    @poll = create_or_update_poll(params,@poll)
    if @poll.errors.full_messages.empty?
      flash[:'alert-success'] = 'Poll was updated.' if !params[:id].nil? #adding more items to the poll
      respond_to do |format|
        format.json{ render :json => {:id => @poll.id}}
      end   
    else
      flash[:"alert-error"] = @poll.errors.full_messages
      respond_to do |format|
        format.json{ render :json => {:errors=> "true"}}
      end  
    end 
  end

  def edit
    authenticate
    @poll = Poll.find(params[:id])
    render "new"
  end

  def update
    if params[:poll][:web_id].nil? # from the direct edit
      @poll = Poll.find(params[:id])
      @items_attributes = Array.new
      params[:items_attributes].each do |key,value|
        item_id = key.gsub('item_','').to_i
        item_attributes = Hash[:id => item_id,:is_deleted => value[:is_deleted],:brand => value[:brand]]
        @items_attributes << item_attributes
        item_attributes = nil
      end
      params[:poll][:items_attributes] = @items_attributes
      if @poll.state == 1
        flash[:'alert-success'] = "Changes were saved." 
      elsif @poll.state == 0  #publish the poll
        params[:poll][:state] = 1 
        #generate_publish_poll_notification @poll #it may result in the timeout error in heroku 
        current_user.poll_publish_reward
        flash[:'alert-success'] = "Your poll was created and published!"
      end
      @poll.update_attributes(params[:poll])
      redirect_to @poll
    else # from the add more items page
      create
    end
  end

  def destroy
    @poll = Poll.find(params[:id])
    @poll.update_attributes(:is_deleted => true)
    flash[:'alert-success'] = "Your poll was deleted successfully."
    render :nothing => true
  end

  def store_choice
    cookies.signed[:item_id] = params["item_id"]
    #puts "store choice: item id is #{cookies.signed[:item_id]}"
    render :nothing => true
  end

  def fb_share
    auth = request.env["omniauth.auth"]
  end
private
  def check_item_id_in_cookies
    #puts "check item id in cookies:cookie is clear." if cookies.signed[:item_id].nil?
    if !cookies.signed[:item_id].nil?
      item = Item.find(cookies.signed[:item_id].to_i)
      #create audience if the voter is not the poll owner
      if current_user == item.poll.user
        flash.now[:notice] = "You can't vote on your own poll."  
        cookies.signed[:item_id] = nil
      else
        create_audience cookies.signed[:item_id]
      end
    end
  end

  def create_item(poll)
    poll.items.build(:photo => params[:img])
  end

  def create_or_update_poll(params,poll)
    params[:poll][:items_attributes] = get_items_attributes params[:items_attributes]
    if poll.nil?
      params[:poll][:category] = params[:poll][:category].to_i
      params[:poll][:user_id] = current_user.id
      params[:poll][:state] = 0
      params[:poll][:open_time] = Time.now.utc
      poll = Poll.create(params[:poll])
    else
      poll.update_attributes(params[:poll])
    end
      #@poll.items.map{|item| puts item.errors.full_messages}
    return poll
  end

  def get_items_attributes params
    params[:creator_id] = current_user.id
    params[:owner_id] = current_user.id
    items_attributes = [params]
  end

  def items_photo_urls items
    urls = Array.new
    items.each do |item|
      urls << item.photo.url(:original)
    end
    return urls
  end
  
end


