class Post  < ActiveRecord::Base

  Filters = []

  require "gravtastic"
  include Gravtastic
  gravtastic :user_email

  include BbcodeFilter
  include TextileFilter
  
  # field :notified, :type => Array, :default => []

  belongs_to :messageboard, :counter_cache => true
  belongs_to :topic,  :counter_cache => true
  belongs_to :user,   :counter_cache => true
  has_many   :images

  validates_presence_of :content, :messageboard_id
  
  attr_accessible :content, :user, :ip, :filter, :topic, :messageboard #, :images_attributes

  before_save :set_user_email
  after_save  :modify_parent_topic

  # misc
  # accepts_nested_attributes_for :images

  def self.filters; Filters; end
  def filters;      Filters; end

  def created_timestamp
    created_at.strftime("%Y-%m-%dT%I:%M:%S-0500") if created_at
  end

  def created_date 
    created_at.strftime("%B %d, %Y") if created_at
  end

  private

    def modify_parent_topic
      topic.last_user = user
      topic.updated_at = created_at
      topic.save
    end

    def set_user_email
      self.user_email = self.user.email if user
    end
    
end
