if Rails.env.development?
	ADMIN_ID = 448
elsif Rails.env.production?
	ADMIN_ID = 474
else
	ADMIN_ID = 448
end
