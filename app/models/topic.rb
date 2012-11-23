class Topic < ActiveRecord::Base
  STATES = %w{pending approved}

  extend FriendlyId
  friendly_id :title, use: :scoped, scope: :messageboard
  paginates_per 50 if self.respond_to?(:paginates_per)

  has_many   :posts, include: :attachments
  has_many   :topic_categories
  has_many   :categories, through: :topic_categories

  belongs_to :last_user, class_name: 'User', foreign_key: 'last_user_id'
  belongs_to :user, counter_cache: true
  belongs_to :messageboard, counter_cache: true, touch: true

  validates_inclusion_of :state, in: STATES
  validates_presence_of :hash_id
  validates_presence_of :last_user_id
  validates_presence_of :messageboard_id
  validates_numericality_of :posts_count
  validates_uniqueness_of :hash_id

  attr_accessible :category_ids,
    :last_user,
    :locked,
    :messageboard,
    :posts_attributes,
    :sticky,
    :type,
    :title,
    :user,
    :usernames

  accepts_nested_attributes_for :posts, reject_if: :updating?
  accepts_nested_attributes_for :categories

  default_scope order('updated_at DESC')

  delegate :name, :name=, :email, :email=, to: :user, prefix: true

  before_validation do
    self.hash_id = SecureRandom.hex(10) if self.hash_id.nil?
  end

  def self.stuck
    where('sticky = true')
  end

  def self.unstuck
    where('sticky = false OR sticky IS NULL')
  end

  def self.on_page(page_num)
    page(page_num).per(30)
  end

  def self.for_messageboard(messageboard)
    where(messageboard_id: messageboard.id)
  end

  def self.order_by_updated
    order('updated_at DESC')
  end

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

    search_words = query.strip.gsub(' ', '&' )
    find_by_sql [sql, search_words, messageboard_id, search_words, messageboard_id]
  end

  def public?
    true
  end

  def private?
    false
  end

  def pending?
    state == 'pending'
  end

  def css_class
    classes = []
    classes << 'locked' if locked
    classes << 'sticky' if sticky
    classes << 'private' if private?
    classes.empty? ?  '' : "class=\"#{classes.join(' ')}\"".html_safe
  end

  def users
    []
  end

  def users_to_sentence
    ''
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

  def categories_to_sentence
    self.categories.map{ |c| c.name }.to_sentence if self.categories
  end
end
