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
    @tags = params[:item][:tags].split(",") #arr
    params[:item].delete(:tags)
    if @item.update_attributes(params[:item])
      @item.update_tags @tags
      flash[:'alert-success'] = 'Updated successfully.'    
    else
      flash[:'alert-error'] = @item.errors.full_messages
    end
    redirect_back_or_default root_path
  end
  def destroy
    item_id = params["item_id"].to_i
    Item.find(item_id).destroy
    render :nothing => true
  end

end
