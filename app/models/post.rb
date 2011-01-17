class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :user, :type => String
  field :content, :type => String
  field :ip, :type => String
  field :notified, :type => Array, :default => []
  embedded_in :topic, :inverse_of => :posts
  validates_presence_of :content
  after_create :modify_parent_topic

  attr_accessible :content, :user, :ip

  private

    def modify_parent_topic
      topic.last_user   = user 
      topic.post_count  += 1
      topic.save
    end

end
