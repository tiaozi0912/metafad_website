if Rails.env == "development"
	Rails.application.config.middleware.use OmniAuth::Builder do
      provider :facebook, '116501321837174', 'd9c705735f7d8fc99ff9a74384072668',  
      :scope => "publish_actions,email", :image_size => 'normal'
                
    end
else
	Rails.application.config.middleware.use OmniAuth::Builder do
	  provider :facebook, '142566439218323','a08795d99fc0fbf0817fb13c700a50fe',
	  :scope => "publish_actions,email",:image_size => 'normal'
	end
end