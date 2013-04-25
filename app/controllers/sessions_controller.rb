class SessionsController < ApplicationController
  def new
  	@title = "Sign In"
  end

  def create 
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    if user.nil?
      flash[:notice] = "Invalid email/password combination."
      @title = "Sign In"
      redirect_to :back
    else
      #Sign in and redirect
      current_user = sign_in user
      flash[:'alert-success'] = "Sign in successfully."
      #redirect_to :back
      redirect_back_or_default(profile_path)
    end
  end

  def create_fb #fb log in
    auth = request.env["omniauth.auth"]
    get_token auth #for debug
    # search fb_id, then search email, then create new user
    user = User.find_by_fb_id(auth["uid"].to_s) || User.find_by_email(auth['info']['email']) || User.create_with_omniauth(auth)

    # ====================================================================
    # move all the previous profile photos from Yong's bucket to Yujun's bucket
    # create the profile photo again by setting has_profile_photo_url false to all the users
    # ====================================================================
    if !user.has_profile_photo_url
      #grab profile photo from fb
      puts 'recreate the profile photo.'
      user.update_attributes(:photo => URI.parse(auth['info']['image'].sub(/square/,'large')),:has_profile_photo_url => true)
    end
    
    sign_in user
    flash[:'alert-success'] = 'Sign in successfully.'
    #redirect_to :back
    redirect_back_or_default(profile_path)
  end

  def create_fb_poll_page
    create_fb
  end

  def fb_signin_failure
    redirect_back_or_default root_path
  end

  def destroy
    sign_out
    flash['alert-success'.to_sym] = "Sign out successfully."
    redirect_to root_path
  end

end
