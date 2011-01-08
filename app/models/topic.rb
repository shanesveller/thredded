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
 
  # associations
  embeds_many :posts
  references_many :users, :stored_as => :array, :inverse_of => :topics # private threads will reference users
  referenced_in :messageboard
  
  # lock it down
  attr_accessible :title, :user, :last_user, :user_ids

  # validations
  validates_numericality_of :post_count, :greater_than => 0
  
  # scopes
  scope :latest, desc(:updated_at)
  
  # misc
  accepts_nested_attributes_for :posts

end
