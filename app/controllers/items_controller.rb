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
  def destroy
    item_id = params["item_id"].to_i
    Item.find(item_id).update_attributes(:is_deleted => true)
    render :nothing => true
  end

end
