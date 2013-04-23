class ItemsController < ApplicationController
  def create
  	#item = Item.create(:photo => params[:img])
  	#render :json => {:item => {:id => item.id,:url => item.photo.url(:medium)}}
  	files = params[:files]
  	#files.each do |file|
  	#	Item.create(:photo => file)
    #end
  	render :nothing => true
  end
  def edit #for admin
    @item = Item.find(params[:id].to_i)
    #@url = '/admin/'
  end
  def update
    @item = Item.find(params[:id].to_i)
    params[:item][:tags] = params[:item][:tags].split(",") #arr
    #params[:item].delete(:tags)
    if @item.update_item_attributes(params[:item])
      #@item.update_tags @tags
      flash[:'alert-success'] = 'Updated successfully.'    
    else
      flash[:'alert-error'] = @item.errors.full_messages
    end
    redirect_back_or_default root_path
  end

  def featured_polls_item_vote
    item = Item.find(params[:id].to_i)
    if current_user.nil?
      #record the vote in cookie, hold on the vote
      store_vote params[:id]
      render :nothing => true 
    else
      if current.vote item
        user_id = current_user.id
        redirect_to = "/web/users/#{user_id}#tab=points/id=#{user_id}"
        store_location redirect_to
        render :nothing => true    
      else
        render :json => {:errors => item.errors.full_messages}
      end
    end   
  end

  def destroy # ajax call
    item_id = params["item_id"].to_i
    Item.find(item_id).destroy
    render :nothing => true
  end

end
