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

  def self.stuck
    where('sticky = true')
  end

  def self.unstuck
    where('sticky = false OR sticky IS NULL')
  end

  # misc
  accepts_nested_attributes_for :posts, :reject_if => :updating?

  # Full Text Search
  def self.full_text_search(query, messageboard_id)
    sql = <<-SQL
    SELECT tops.*, pork.score * 100 as posts_count
      FROM (
        SELECT meat.id as id, sum(meat.rank) as score
          FROM (
            SELECT t.id as id, ts_rank(setweight(to_tsvector(p.content), 'B'), pquery) as rank
              FROM topics t, posts p, to_tsquery('english', ?) as pquery
             WHERE t.messageboard_id = ?
               AND t.id              = p.topic_id
               AND to_tsvector('english', p.content) @@ pquery
             UNION ALL
            SELECT t.id as id, ts_rank( setweight(to_tsvector('english', t.title), 'A'), tquery ) as rank
              FROM topics t, to_tsquery('english', ?) as tquery
             WHERE t.messageboard_id = ?
               AND to_tsvector('english', t.title) @@ tquery
               ) meat
         GROUP BY meat.id
         ORDER BY score desc LIMIT 50 OFFSET 0
           ) pork, topics tops
         where pork.id = tops.id
    SQL

    search_words = query.gsub(' ', '&' )
    self.find_by_sql [sql, search_words, messageboard_id, search_words, messageboard_id]
  end

  # TODO: Remove permission column from Topics table
  def public? 
    self.class.to_s == "Topic"
  end

  def private?
    self.class.to_s == "PrivateTopic"
  end

  def css_class
    classes = []
    classes << "locked" if locked
    classes << "sticky" if sticky
    if classes.empty?
      ""
    else
      "class=\"#{classes.join(' ')}\"".html_safe
    end
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

  def updating?
    self.id.present?
  end
end
