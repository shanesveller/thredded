class Topic < ActiveRecord::Base

  paginates_per 50 if self.respond_to?(:paginates_per)

  # associations
  has_many   :posts, :include => :attachments
  has_many   :topic_post_searches
  belongs_to :last_user, :class_name => "User", :foreign_key => "last_user_id"
  belongs_to :user, :counter_cache => true
  belongs_to :messageboard, :counter_cache => true, :touch => true
  belongs_to :category
  
  # delegations
  delegate :name, :name=, :email, :email=, :to => :user, :prefix => true

  # validations
  validates_presence_of [:last_user_id, :messageboard_id]
  validates_numericality_of :posts_count

  # lock it down
  attr_accessible :type, :title, :user, :last_user, :sticky, :locked, :usernames, :posts_attributes, :messageboard
  
  # scopes
  default_scope order('updated_at DESC')
  default_scope where('type IS NULL')
  
  # misc
  accepts_nested_attributes_for :posts


  # let's slim this down a little bit
  [:locked].each do |field|
    class_eval %Q{
      def #{field}
        return "0" if self.attribs.nil?
        self.attribs = ActiveSupport::JSON.decode( self.attribs ) if self.attribs.class == String
        @#{field} = self.attribs.include?("#{field}") ? "1" : "0"
      end

      def #{field}=(state)
        self.attribs = "[]" if self.attribs.nil?
        current_attribs = ActiveSupport::JSON.decode( self.attribs )
        current_attribs.delete("#{field}") if state == "0" &&  current_attribs.include?("#{field}")
        current_attribs << "#{field}"      if state == "1" && !current_attribs.include?("#{field}")
        self.attribs = ActiveSupport::JSON.encode( current_attribs )
        return state
      end
    }
  end
 
  # Full Text Search
  def self.full_text_search(query, messageboard_id)
    sql = <<-SQL
    SELECT t.*
      FROM topics t, posts p
     WHERE t.messageboard_id = ?
       and p.topic_id        = t.id
       and  to_tsvector('english', p.content) @@ to_tsquery('english', ?)
     UNION 
    SELECT t.*
      FROM topics t
     WHERE t.messageboard_id = ?
       AND to_tsvector('english', t.title) @@ to_tsquery('english', ?)
    SQL

    search_words = query.sub(' ', '|')
    self.find_by_sql [sql, messageboard_id, search_words, messageboard_id, search_words]
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
