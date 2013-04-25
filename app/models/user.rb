class User < ActiveRecord::Base
    
  #create a virtual password attribute
  attr_accessor :password
  attr_accessible :user_name, :email, :password, :password_confirmation,:profile_photo_url, :fb_id,:photo, :point,:last_name,:first_name,:pre_sign_up,:has_profile_photo_url,:current_login_at,:last_login_at,:current_login_ip,:last_login_ip,:updated_at,:login_count
  
  has_many :events, :dependent => :destroy
  has_many :polls, :dependent => :destroy
  has_many :poll_records, :dependent => :destroy 

  has_many :relationships, :foreign_key => "follower_id",
                           :dependent => :destroy
  # user.following for array of followed users. :source parameter explicityly tells rails that the source of the following array is the set of followed ids
  has_many :following, :through => :relationships, :source => :followed
  has_many :reverse_relationships, :foreign_key => "followed_id",
                                   :class_name => "Relationship",
                                   :dependent => :destroy
  has_many :followers, :through => :reverse_relationships, :source => :follower

  has_many :apn_devices, :dependent => :destroy
  has_many :apn_notifications, :dependent => :destroy
  has_many :shared_polls, :dependent => :destroy
  has_many :comments,:through => :comments,:dependent => :destroy
  has_many :point_actions, :dependent => :destroy


  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  #validates :user_name, :presence => true, :length => { :maximum => 50 }

  validates :email, :presence => true,
                    :format =>{ :with => email_regex },
                    :uniqueness =>{ :case_sensitive => false }

  validates :password, :confirmation => true

  has_attached_file :photo,
                    :styles => { :thumbnail => "25x25#",
                                   :small => "40x40>",
                                   :medium => "55x55>",
                                   :large => "125x125>" },
                    :storage => :s3,
                    :s3_credentials => S3_CREDENTIALS,
                    :url=>"/user_:id/created_at_:created_at/:style.jpg",
                    :path => '/app/public/users:url'

  Paperclip.interpolates :created_at do |attachment, style|
    attachment.instance.created_at
  end
  #:presence => true,
                       #:confirmation => true,
                       #:length => { :within => 6..40 }

  #before_save :encrypt_password
  def has_password?(submitted_password)
    crypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end
  
  #create user with the fb authentication
  def self.create_with_omniauth(auth)
    create! do |user|
      user.email = auth['info']['email']
      user.user_name = auth['info']['name']
      user.gender = auth['extra']['raw_info']['gender']
      user.fb_id = auth['uid'].to_s
      password=auth['info']['name']
      #grap fb photo
      user.photo = URI.parse(auth['info']['image'].sub(/square/,'large'))
      user.has_profile_photo_url = true

      user.encrypt_password password
      #user.crypted_password = auth['credentials']['token']
      #user.password_salt = auth['credentials']['token']
    end
    # good until the app is released
    pre_sign_up_action
  end

  def picture_from_url url
    self.photo = URI.parse(url) 
  end

  def self.authenticate_with_salt(id,cookie_salt)
    user = find_by_id(id)
    (user && user.password_salt == cookie_salt ) ? user : nil
  end

  def feed
    Event.where("user_id= ?",id)
  end

  def following?(followed)
    !relationships.find_by_followed_id(followed).nil?
  end

  def follow!(followed)
    relationships.create!(:followed_id => followed)
  end

  def unfollow!(followed)
    relationships.find_by_followed_id(followed).destroy 
  end

  def encrypt_password password
    self.password_salt = make_salt if new_record?
    self.crypted_password = encrypt(password)
  end

  def photo_url_with_style(style)
    if has_profile_photo_url
      url = photo.url(style.to_sym)
    else
      url = default_profile_photo_url
    end
  end

  def to_json *arg #{:photo_style => 'large',:point_action_count => 20,...}
    default = {
      :photo_style => 'small',
      :point_action_count => 30
    }
    if arg.length > 0
      photo_style = arg[0][:photo_style] # could be nil
      count = arg[0][:point_action_count]
      count ||= default[:point_action_count]
        case arg[0][:tab]
        when 'points'
          extra = {
            :points => point_actions[0..count].map do |pa|
              pa.to_json
            end
          }
        when 'coupons'
          #fetch user's redeemed coupons
          extra = {}
        when 'stores'
          # fetch retailers' coupons for redeem
          extra = {}
        end
      
    end
    photo_style ||= default[:photo_style]
    base = {
      :id => id,
      :user_name => user_name,
      :point => point,
      :photo_url => photo_url_with_style(photo_style),
      :number_of_votes => number_of_votes,
      :rank => rank,
      :email => email
    }
    base.merge extra
  end

  #Earn point when publishing poll
  def poll_publish_reward
    self.point = self.point + Reward.point_rewards[:publish_poll]
    self.save
  end

  def vote_action poll,item # update the points earned and record the point action
    content = "for voting to \n " + poll.user.user_name + " \n " + poll.title + " poll"
    reward_points = Reward.point_rewards[:vote]
    thumbnail = item.photo(:thumbnail)
    create_point_action(content,reward_points,poll.id,thumbnail,2)
    reward :vote
  end

  def pre_sign_up_action
    content = "for the app pre-launch sign up"
    reward_points = Reward.point_rewards[:pre_sign_up]
    thumbnail = '/images/icons/pre_signup_icon.png'
    create_point_action(content,reward_points,poll.id,thumbnail,4)
    reward :pre_sign_up
  end

  def create_point_action(content,point,poll_id,thumbnail,type)
    point_actions.create(:poll_id => poll_id,:point => point,:content => content,:thumbnail => thumbnail,:action_type => type)
  end

  def reward reward_type
    self.point += Reward.point_rewards[reward_type]
    self.save
  end

  def vote item
    vote_action item.poll,item
    item.update_number_of_votes
  end

  def default_profile_photo_url
    '/images/default-profile-photo.png'
  end

  private

    def encrypt(string)
      secure_hash("#{password_salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end

end
