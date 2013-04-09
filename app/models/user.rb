# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  user_name           :string(255)      not null
#  email               :string(255)      not null
#  crypted_password    :string(255)      not null
#  password_salt       :string(255)      not null
#  persistence_token   :string(255)      not null
#  single_access_token :string(255)      not null
#  perishable_token    :string(255)      not null
#  login_count         :integer          default(0), not null
#  failed_login_count  :integer          default(0), not null
#  last_request_at     :datetime
#  current_login_at    :datetime
#  last_login_at       :datetime
#  current_login_ip    :string(255)
#  last_login_ip       :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class User < ActiveRecord::Base
    
  #create a virtual password attribute
  attr_accessor :password
  attr_accessible :user_name, :email, :password, :password_confirmation,:profile_photo_url, :fb_id,:photo, :point,:last_name,:first_name,:pre_sign_up
  
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
                    :url=>"/user_:id/created_at_:created_at/:style.jpg"

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

  def self.create_with_omniauth(auth)
    create! do |user|
      user.email = auth['info']['email']
      user.user_name = auth['info']['name']
      user.gender = auth['extra']['raw_info']['gender']
      user.photo = URI.parse(auth['info']['image'])
      user.has_profile_photo_url = true
      user.fb_id = auth['uid'].to_s
      password=auth['info']['name']
      user.encrypt_password password
      #user.crypted_password = auth['credentials']['token']
      #user.password_salt = auth['credentials']['token']
    end
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
      url = nil
    end
  end

  #Earn point when publishing poll
  def poll_publish_reward
    self.point = self.point + Reward.point_rewards[:publish_poll]
    self.save
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
