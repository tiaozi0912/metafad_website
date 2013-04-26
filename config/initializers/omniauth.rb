if Rails.env.production?
	FB_ID = '142566439218323'
	FB_SECRET = 'a08795d99fc0fbf0817fb13c700a50fe'
	DOMAIN = 'www.metafad.com'
else
	FB_ID = '116501321837174'
	FB_SECRET = 'd9c705735f7d8fc99ff9a74384072668'
	DOMAIN = 'localhost:3000'
end

OmniAuth.config.logger = Rails.logger
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, FB_ID, FB_SECRET,
  :scope => "publish_actions,email", :image_size => 'normal'
end