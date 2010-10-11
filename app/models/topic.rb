class Topic
  include Mongoid::Document
  include Mongoid::Timestamps
  field :permission, :type => String
  field :user, :type => String
  field :last_user, :type => String
  field :title, :type => String
  field :post_count, :type => Integer, :default => 1
  field :attributes, :type => Array, :default => []
  field :categories, :type => Array, :default => []
  field :subscribers, :type => Array, :default => []
  
  attr_accessible :user, :title
end