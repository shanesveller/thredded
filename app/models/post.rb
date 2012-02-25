class Post  < ActiveRecord::Base
  require "gravtastic"
  include Gravtastic
  include BaseFilter
  include TextileFilter
  include BbcodeFilter
  include AttachmentFilter
  
  gravtastic :user_email
  default_scope :order => 'id ASC'
  belongs_to :messageboard, :counter_cache => true
  belongs_to :topic,  :counter_cache => true
  belongs_to :user,   :counter_cache => true
  has_many   :attachments
  accepts_nested_attributes_for :attachments
  validates_presence_of :content, :messageboard_id
  attr_accessible :content, :user, :ip, :filter, :topic, :messageboard, :attachments_attributes
  before_save :set_user_email
  after_save  :modify_parent_topic

  def created_timestamp
    created_at.strftime("%Y-%m-%dT%H:%M:%S") if created_at
  end

  def created_date 
    created_at.strftime("%b %d, %Y %I:%M:%S %Z") if created_at
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
