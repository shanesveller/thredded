class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :user, :type => String
  field :content, :type => String
  field :ip, :type => String
  field :notified, :type => Array, :default => []
  embedded_in :topic, :inverse_of => :posts

  attr_accessible :content
end
