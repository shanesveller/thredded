class Topic < ActiveRecord::Base

  paginates_per 50 if self.respond_to?(:paginates_per)
  
  # associations
  has_many   :posts
  belongs_to :last_user, :class_name => "User", :foreign_key => "last_user_id"
  belongs_to :user, :counter_cache => true
  belongs_to :messageboard, :counter_cache => true
  
  # delegations
  delegate :name, :name=, :email, :email=, :to => :user, :prefix => true

  # validations
  validates_presence_of :messageboard_id
  validates_numericality_of :posts_count

  # lock it down
  attr_accessible :type, :title, :user, :last_user, :sticky, :locked, :usernames, :posts_attributes, :messageboard
  
  # scopes
  default_scope :order => 'updated_at DESC'
  
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
  
  # TODO: Remove permission column from Topics table
  def public? 
    self.class.to_s == "Topic"
  end

  def private?
    self.class.to_s == "PrivateTopic"
  end

  def users_to_sentence
    @users_to_sentence ||= self.users.collect{ |u| u.name.capitalize }.to_sentence if self.class == "PrivateTopic" && self.users
  end

  def self.inherited(child)
    child.instance_eval do
      def model_name
        Topic.model_name
      end
    end
    super
  end

  def self.select_options
    subclasses.map{ |c| c.to_s }.sort
  end

end
