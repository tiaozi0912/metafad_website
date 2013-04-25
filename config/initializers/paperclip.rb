Paperclip::Attachment.default_options[:fog_credentials] = {:provider => "Local", :local_root => "/Users/yujunwu/museme-server-end/public"}

if Rails.env.production?
	Paperclip::Attachment.default_options[:item_path] = '/app/public/items:url'
else
   Paperclip::Attachment.default_options[:item_path] = '/app/public:url'
end