class Item < ActiveRecord::Base
	attr_accessible :photo, :photo_url, :poll_id, :brand, :number_of_votes,:description, :is_deleted,:creator_id, :owner_id
  has_many :comments, :dependent => :destroy
  has_many :flags
  validates :brand, :length => { :maximum => 33 }

	has_attached_file :photo,
                    :styles => { :thumbnail => "100x100#",
                                   :small => "160x160>",
                                   :medium => "320x320>",
                                   :large => "640x640>" },
                    :storage => :s3,
                    :s3_credentials => S3_CREDENTIALS,
                    :url=>"/item_:id/created_at_:created_at/:style.jpg",
                    :path => '/app/public:url'
	belongs_to :poll
  serialize :tags
  Max_Attachments = 100
  Max_Attachment_Size = 10.megabyte

	default_scope :order => 'items.created_at DESC'

  Paperclip.interpolates :created_at do |attachment, style|
    attachment.instance.created_at
  end

	def photo_url_with_style(style)
    if photo_url.nil?
    	url = photo.url(style.to_sym)
    else
    	url = photo_url
    end
  end

  def item_voters
    voter_ids = poll.audiences.where('has_voted = ?',id).map(&:user_id).uniq
    puts voter_ids.to_s
    return User.where('id IN (?)',voter_ids)
  end  

end
