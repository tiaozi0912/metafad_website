class NotificationsMailer < ActionMailer::Base
  default :from => "faddi-care@metafad.com"

  def new_message(message)
    @message = message
    mail(:subject => "[MetaFad] #{message.subject}",:to => "info@metafad.com")
  end

  def consumer_welcome_email user
  	@user = user
  	email_with_name = "#{@user.first_name} <#{@user.email}>"
  	mail(:to => email_with_name,:subject => "Welcome to MetaFad!")
  end

  def retailer_welcome_email retailer
  	@retailer = retailer
  	email_with_name = "#{@retailer.name} <#{@retailer.email}>"
  	mail(:to => email_with_name,:subject => "Welcome to MetaFad!",:bcc => ["wyj0912@gmail.com","m@metafad.com"])
  end

end
