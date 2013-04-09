class Retailer < ActiveRecord::Base
  attr_accessible :name, :email, :website, :pre_sign_up
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates :name, :presence => true
  validates :website, :presence => true
  validates :email, :presence => true,
                    :format =>{ :with => email_regex },
                    :uniqueness =>{ :case_sensitive => false }
end
