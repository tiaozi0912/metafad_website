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

  def consumer # it's the main page of the website
    cookies.signed[:page] = 'consumers'
    @form_header = "Sign Up To Get Bonus Points"
    #@imgs = Dir.glob('public/images/gallery/colors/dusk_blue/*')
    clear_cookies
  end

  def retailer
    cookies.signed[:page] = 'retailers'
    @form_header = "Sign Up To Get Free Trial"
    clear_location
  end

  def gallery
    @category = params[:category] #string
    #category_num = Poll.category_to_num @category
    #@polls = User.find(ADMIN_ID).polls.where('category = ?',@category)
    #query in this way faster
    @polls = Poll.where('user_id = ? AND category = ?',ADMIN_ID,@category);
    @polls_to_json = @polls.map {|p| p.to_json({:photo_style => 'small'})}
    render :json => {:polls => @polls_to_json}
  end

end
