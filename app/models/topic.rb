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
  attr_accessor :usernames

  # validations
  validates_numericality_of :post_count, :greater_than => 0
  validates_presence_of :messageboard_id

  # scopes
  scope :latest, desc(:updated_at)
  
  # misc
  accepts_nested_attributes_for :posts

  def public? 
    self.users.empty?
  end

  def private?
    self.users.present?
  end

  def add_user(name_or_obj)
    if name_or_obj.class == String
      @user = User.where(:name => name_or_obj).first
    elsif name_or_obj.class == User
      @user = name_or_obj
    end

    self.users << @user
  end

  def users_to_sentence
    @users_to_sentence ||= self.users.collect{ |u| u.name.capitalize }.to_sentence
  end

end
