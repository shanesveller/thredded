class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :user, :type => String
  field :content, :type => String
  field :ip, :type => String
  field :notified, :type => Array, :default => []
  embedded_in :topic, :inverse_of => :posts
  validates_presence_of :content

  attr_accessible :content, :user
end
