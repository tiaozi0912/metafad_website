class Poll < ActiveRecord::Base
	attr_accessible :title, :user_id, :state, :is_deleted,:total_votes,:max_votes_for_single_item, :end_time, :category, :open_time, :items_attributes, :web_id,:is_featured,:description
  validates :title, :presence => true, :length => { :maximum => 90 }
  validates :category, :presence => true
	belongs_to :user
	has_many :items, :dependent => :destroy
	accepts_nested_attributes_for :items
	has_many :audiences, :dependent => :destroy
	has_many :poll_records,:dependent => :destroy
	has_one :event,:dependent => :destroy
	has_one :shared_poll,:dependent => :destroy
  has_many :point_actions

	default_scope :order => 'polls.created_at DESC'

	validate :validate_attachments
	def validate_attachments
  errors[:base] << "Too many attachments - maximum is #{Item::Max_Attachments}" if items.length > Item::Max_Attachments
    items.each {|i| errors[:base] << "#{i.photo_file_name} is over #{Item::Max_Attachment_Size/1.megabyte}MB" if i.photo_file_size > Item::Max_Attachment_Size}
  end
    
  def poll_voters
  voter_ids = audiences.where('has_voted != 0').map(&:user_id).uniq
    return User.where('id IN (?)',voter_ids)
  end

  def self.colors
  	return {
  		'dusk_blue' => 'rgb(91,145,181)',
         'linen' => 'rgb(241,208,181)',
         'poppy_red'=>'rgb(200,20,20)',
         'emerald'=>'rgb(0,150,127)',
         'grayed_jade'=>'rgb(141,171,163)',
         'lemon_zest'=>'rgb(254,219,63)',
         'monaco_blue'=>'rgb(24,43,83)',
         'nectarine'=>'rgb(243,113,51)',
         'rose_smoke'=>'rgb(223,193,185)',
         'tender_shoots'=>'rgb(163,190,57)',
         'violet'=>'rgb(153,108,175)'
      }
  end

  def self.brands
    return ['burberry','celine','chanel','chloe','christian_dior','dolce_&_gabbana','donnakaran','elie_saab','fendi','valentino']
  end

  def self.category_to_num str
    case str
    when 'colors'
      num = 0
    when 'brands'
      num = 1
    else
      num = 2
    end
    return num
  end
  
  def to_json *arg #{:photo_style => 'large',..}
    json = {
      :id => id,
      :category => category,
      :title => title,
      :date => open_time.localtime.strftime('%m/%d/%Y'),
      :url => url,
      :description => description,
      :items => items.map do |item|
        item.to_json *arg
      end
    }
  end

  def url
    default = "/polls/#{id}"
    #for the featured polls
    default = "/#featured-polls-section/polls/#{id}" if is_featured 
    return default
  end

end