class UsersController < ApplicationController

  def new
  	@user = User.new
    @title = "Sign Up"
  end

  def show
  	@user = User.find(params[:id])
  	@title = @user.user_name
    # if there is held vote, submit the vote
    if !cookies.signed[:item_id].nil?
      item = Item.find(cookies.signed[:item_id].to_i)
      current_user.vote item if !current_user.nil?
    end
    clear_cookies
  end

  def create
    @user = User.new(params[:user])
    @user[:user_name] ||= @user[:email].match(/^[^@]+/).to_s
    @user.encrypt_password(params[:user][:password])
    if @user.save
      #handle a successful case
      current_user = sign_in @user
      NotificationsMailer.consumer_welcome_email(@user).deliver
      @user.pre_sign_up_action
      flash[:'alert-success'] = "Welcome to MetaFad!"
      # equal to redirect_to user_path(@user)
      redirect_back_or_default profile_path
    else
      @title = "Sign Up"
      render 'new'
    end
  end

  def edit
    if authenticate
      @valid = (params[:id].to_i == current_user.id)
      redirect_to settings_path if !@valid
    end
  end

  def update
    user = User.find(params[:id].to_i)
    params[:user][:updated_at] = Time.new.utc
    if user.update_attributes(params[:user])
      flash[:'alert-success'] = 'Updates saves successfully.'
    else
      flash[:'alert-error'] = user.errors.full_messages
    end
    redirect_to settings_path
  end

  def update_profile_photo_ajax
    user = User.find(params[:id].to_i)
    params[:user][:has_profile_photo_url] = true
    params[:user][:updated_at] = Time.new.utc
    if user.update_attributes(params[:user])
      render :json => {:photo_url => user.photo_url_with_style('large')}
    else
      render :json => {:error => user.errors.full_messages}
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
    @user = current_user
    NotificationsMailer.consumer_welcome_email(@user).deliver
    redirect_to '/show_email'
  end

  def show_email
    @user = current_user
    render 'notifications_mailer/consumer_welcome_email',:layout => false
  end

  def user_to_json
    @user = User.find(params[:id].to_i)
    @tab = params[:tab]
    render :json => @user.to_json({:tab => @tab})
  end

end
