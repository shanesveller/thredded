class Topic
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :title, :type => String
  field :user, :type => String
  field :last_user, :type => String
  field :post_count, :type => Integer, :default => 1
  field :attribs, :type => Array, :default => []
  field :categories, :type => Array, :default => []
  field :tags, :type => Array, :default => []
  field :subscribers, :type => Array, :default => []

  referenced_in :messageboard

  embeds_many :posts
  accepts_nested_attributes_for :posts
  
  attr_accessible :user, :title
end
