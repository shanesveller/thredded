class Post

  Filters = []

  require "gravtastic"
  require "bbcode_filter"
  require "textile_filter"

  include Mongoid::Document
  include Mongoid::Timestamps
  include Gravtastic
  include BbcodeFilter
  include TextileFilter

  gravtastic :user_email
  
  field :user, :type => String
  field :user_email, :type => String  # why?  for gravatars, natch
  field :content, :type => String
  field :ip, :type => String
  field :notified, :type => Array, :default => []
  field :filter, :type => Symbol, :default => :bbcode

  embedded_in :topic, :inverse_of => :posts
  references_many :images

  validates_presence_of :content
  before_create :set_user_email
  after_create :modify_parent_topic
  after_create :incr_user_posts_count
  attr_accessible :content, :user, :ip

  # misc
  accepts_nested_attributes_for :images

  def self.filters
    Filters
  end

  private

    def modify_parent_topic
      topic.last_user   = user 
      topic.post_count  += 1
      topic.save
    end

    def incr_user_posts_count
      @user ||= User.where(:name => self.user).first
      @user.inc(:posts_count, 1) if @user
    end

    def set_user_email
      @user ||= User.where(:name => self.user).first
      self.user_email = @user.email if @user
    end
    
end
