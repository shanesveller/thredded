class Topic
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :title, :type => String
  field :user, :type => String
  field :slug, :type => String
  field :last_user, :type => String
  field :post_count, :type => Integer, :default => 0
  field :attribs, :type => Array, :default => []
  field :categories, :type => Array, :default => []
  field :tags, :type => Array, :default => []
  field :subscribers, :type => Array, :default => []
  field :permission, :type => Symbol, :default => :public
  
  validates_numericality_of :post_count, :greater_than => 0
  
  attr_accessible :title, :user, :last_user

  referenced_in :messageboard
  embeds_many :posts
  accepts_nested_attributes_for :posts
  
  scope :latest, desc(:updated_at)
end
