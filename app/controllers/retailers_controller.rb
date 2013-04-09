class RetailersController < ApplicationController

	def pre_sign_up
    params[:retailer][:pre_sign_up] = true
    @retailer = Retailer.new(params[:retailer])
    if @retailer.save
      flash[:"alert-success"] = "Thanks for signing up! A confirm email with follow-up information is sent to you." 
      NotificationsMailer.retailer_welcome_email(@retailer).deliver
    else
      flash[:"alert-error"] = "Sorry, but " + @user.errors.full_messages.to_sentence
    end
    redirect_to '/retailers'
	end
end
