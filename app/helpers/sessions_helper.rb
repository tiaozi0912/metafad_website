module SessionsHelper

	def sign_in(user)
        user.update_attributes(:login_count => user.login_count + 1,
            :current_login_at => Time.new.utc,
            :current_login_ip => request.remote_ip,
            #good until the ios app is released
            :pre_sign_up => true
        )
		cookies.permanent.signed[:remember_token] = [user.id, user.password_salt]
		current_user = user
	end

    # designed to returen the value of @current_user
    def current_user
    	@current_user  ||= user_from_remember_token
    end

    def sign_out
        current_user.update_attributes(:last_login_at => Time.new.utc,
            :last_login_ip => request.remote_ip,
        )
    	cookies.delete(:remember_token)
    	current_user = nil
    end

    def signed_in?
      !current_user.nil?
    end
    
    private

    def user_from_remember_token
    	User.authenticate_with_salt(*remember_token)
    end

    def remember_token
    	cookies.signed[:remember_token] || [nil, nil]
    end

end
