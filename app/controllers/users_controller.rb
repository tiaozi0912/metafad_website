class UsersController < ApplicationController

  def new
  	@user = User.new
    @title = "Sign Up"
  end

  def show
  	@user = User.find(params[:id])
  	@title = @user.name
  end

  def create
    @user = User.new(params[:user])
    @user[:user_name] ||= @user[:email].match(/^[^@]+/).to_s 
    @user.encrypt_password(params[:user][:password])
    if @user.save
      #handle a successful case
      current_user = sign_in @user
      flash[:'alert-success'] = "Welcome to MetaFad!"
      # equal to redirect_to user_path(@user)
      redirect_back_or_default root_path
    else
      @title = "Sign Up"
      render 'new'
    end
  end

  def pre_sign_up
    params[:user][:pre_sign_up] = true
    params[:user][:user_name] = params[:user][:first_name] + "_" + params[:user][:last_name]
    @user = User.new(params[:user])
    if @user.save
      flash[:"alert-success"] = "Sign up successfully. You have earned 500 points! A confirm email is sent to you." 
      NotificationsMailer.consumer_welcome_email(@user).deliver
    else
      flash[:"alert-error"] = "Sorry, but " + @user.errors.full_messages.to_sentence
    end
    redirect_to '/consumers'
  end

  def test_email
    @user = User.find(444)
    NotificationsMailer.consumer_welcome_email(@user).deliver
    redirect_to '/consumers'
  end

end
