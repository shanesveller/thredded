class Topic
  include Mongoid::Document
  include Mongoid::Timestamps
  before_create :add_user_info
  
  field :title, :type => String
  field :user, :type => String
  field :slug, :type => String
  field :last_user, :type => String
  field :post_count, :type => Integer
  field :attribs, :type => Array, :default => []
  field :categories, :type => Array, :default => []
  field :tags, :type => Array, :default => []
  field :subscribers, :type => Array, :default => []

  referenced_in :messageboard

  embeds_many :posts
  accepts_nested_attributes_for :posts
  
  attr_accessible :title

  private
    def add_user_info
      debugger
      self.user = self.last_user =  ""
    end
end
