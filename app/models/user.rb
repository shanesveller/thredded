class User < ActiveRecord::Base
  include ActiveModel::Dirty

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :time_zone

  # has_and_belongs_to_many :messageboards
  has_many :sites
  has_many :roles
  has_many :messageboards, :through => :roles
  has_many :topics
  has_many :posts
  has_many :private_users
  has_many :private_topics, :through => :private_users
  
  # validates_numericality_of :posts_count, :topics_count
  validates_presence_of :name
  validates :name, :presence => true, :uniqueness => true, :format => { :with => /\A[a-zA-Z0-9]+\z/, :message => "only letters or numbers allowed" }
  validates :email, :presence => true, :length => {:minimum => 3, :maximum => 254}, :uniqueness => true, :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "invalid email address"}
  

  after_save :update_posts

  def superadmin?
    valid? && self.superadmin
  end

  def admins?(messageboard)
    valid? && (superadmin? || roles.for(messageboard).as(['admin']).size > 0)
  end

  def moderates?(messageboard)
    valid? && (superadmin? || roles.for(messageboard).as([:admin, :moderator]).size > 0)
  end

  def member_of?(messageboard)
    valid? && (superadmin? || roles.for(messageboard).as([:admin, :moderator, :member]).size > 0)
  end
  
  def member_of(messageboard, as='member')
    roles << Role.create(:level => as, :messageboard => messageboard) and save
  end

  def admin_of(messageboard)
    member_of(messageboard, 'admin')
  end

  def can_post_to?(messageboard)
    messageboard.posting_for_anonymous? || (messageboard.posting_for_logged_in? && self.logged_in?) || (messageboard.posting_for_members? && self.member_of?(messageboard) )
  end

  def logged_in?
    valid?
  end

  def to_param
    self.name
  end

  private 
    def update_posts
      if self.email_changed?
        Post.update_all(["user_email = ?", self.email], ["user_email = ?", self.email_was])
      end
    end

end
