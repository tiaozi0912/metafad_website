class ContactsController < ApplicationController
  def new
    @message = Message.new
  end

  def create
    @message = Message.new(params[:message])
    
    if @message.valid?
      NotificationsMailer.new_message(@message).deliver
      flash[:"alert-success"] = "Message was successfully sent. Thanks for writing to us."
      redirect_to root_path  
    else
      flash.now[:"alert-error"] = "Please fill all fields."
      render :new
    end
  end

end
