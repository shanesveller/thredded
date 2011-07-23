class Topic < ActiveRecord::Base

  # field :slug, :type => String
  # field :attribs, :type => Array, :default => []
  # field :categories, :type => Array, :default => []
  # field :tags, :type => Array, :default => []
  # field :subscribers, :type => Array, :default => []
  # slug  :title, :scope => :messageboard
 
  # pagination
  paginates_per 50

  # associations
  has_many :posts
  belongs_to :last_user, :class_name => "User", :foreign_key => "last_user_id"
  belongs_to :user, :counter_cache => true
  belongs_to :messageboard, :counter_cache => true
  
  # lock it down
  attr_accessible :title, :user, :last_user, :user_ids, :sticky, :locked, :usernames, :posts_attributes
  
  # validations
  validates_numericality_of :post_count
  validates_presence_of :messageboard_id

  # scopes
  scope :latest, desc(:updated_at)
  
  # misc
  accepts_nested_attributes_for :posts

  # let's slim this down a little bit
  [:sticky, :locked].each do |field|
    class_eval %Q{
      def #{field}
        @#{field} = attribs.include?("#{field}") ? "1" : "0"
      end

      def #{field}=(state)
        attribs.delete("#{field}") if state == "0" &&  attribs.include?("#{field}")
        attribs << "#{field}"      if state == "1" && !attribs.include?("#{field}")
      end
    }
  end

  def usernames 
    users.collect{ |u| u.name }.join(', ')
  end

  def usernames=(usernames)
    user_ids.clear if usernames.empty?

    usernames.split(',').each do |name|
      user = User.where(:name => name.strip).first
      users << user if user && user.present?
    end
    users
  end

  def public? 
    self.users.empty? if self.users
  end

  def private?
    self.users.present? if self.users
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
