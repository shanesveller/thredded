class Post  < ActiveRecord::Base

  Filters = []

  require "gravtastic"
  # require "bbcode_filter"
  # require "textile_filter"

  include Gravtastic
  # include BbcodeFilter
  # include TextileFilter

  gravtastic :user_email
  
  # field :user, :type => String
  # field :user_email, :type => String  # why?  for gravatars, natch
  # field :content, :type => String
  # field :ip, :type => String
  # field :notified, :type => Array, :default => []
  # field :filter, :type => Symbol, :default => :bbcode

  # embedded_in :topic, :inverse_of => :posts
  # references_many :images

  validates_presence_of :content
  before_create :set_user_email
  after_create :modify_parent_topic
  after_create :incr_user_posts_count
  attr_accessible :content, :user, :ip, :filter, :images_attributes

  # misc
  # accepts_nested_attributes_for :images

  def self.filters
    Filters
  end

  def filters
    Filters
  end

  def created_timestamp
    created_at.strftime("%Y-%m-%dT%I:%M:%S-0500") if created_at
  end

  def created_date 
    created_at.strftime("%B %d, %Y") if created_at
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
