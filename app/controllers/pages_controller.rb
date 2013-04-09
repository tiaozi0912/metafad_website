class PagesController < ApplicationController
  def home
    @title = 'Home'
    cookies.signed[:return_to] = '/polls/new'
  end

  def contact
    cookies.signed[:page] = 'consumers'
  	@title ="Contact"
  end

  def about
    cookies.signed[:page] = 'consumers' 
  	@title ="About"
  end

  def consumer
    cookies.signed[:page] = 'consumers'
    @form_header = "Sign Up To Get Bonus Points"
    @imgs = Dir.glob('public/images/gallery/colors/dusk_blue/*')
    puts 'count images'
    puts @imgs.count
    render 'consumer'
  end

  def retailer
    cookies.signed[:page] = 'retailers'
    @form_header = "Sign Up To Get Free Trial"
    render 'retailer'
  end

end
