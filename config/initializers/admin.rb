if Rails.env.development?
	ADMIN_ID = 448
elsif Rails.env.production?
	AMDIN_ID = 474
else
	AMDIN_ID = 448
end
