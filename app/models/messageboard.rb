class Messageboard < ActiveRecord::Base

  SECURED_WITH = ['private', 'logged_in', 'public']
  POSTS_ALLOWED_BY = ['members', 'logged_in', 'anonymous']

  validates_numericality_of :topics_count
  validates_inclusion_of  :security, :in => SECURED_WITH
  validates_inclusion_of  :posting_permission, :in => POSTS_ALLOWED_BY
  validates_presence_of   :name, :title
  validates_format_of     :name, :with => /^[\w\-]+$/, :on => :create, :message => "should be letters, nums, dash, underscore only."
  validates_uniqueness_of :name, :message => "must be a unique board name. Try again.", :scope => :site_id
  validates_length_of     :name, :within => 1..16, :message => "should be between 1 and 16 characters" 

  belongs_to :site
  has_many :topics
  has_many :posts
  # TODO : Figure out what's wrong with this HABTM relationship
  # has_and_belongs_to_many :users #, :inverse_of => :messageboards
  has_many :roles
  
  def restricted_to_private?
    security == 'private'
  end
  
  def restricted_to_logged_in?
    security == 'logged_in'
  end
  
  def public?
    security == 'public'
  end

  def default_home_is_topics?
     THREDDED[:default_messageboard_home] == 'topics'
  end

  def default_home_is_home?
     THREDDED[:default_messageboard_home] == 'home'
  end

  
  def to_param
    "#{name.downcase}"
  end

end
