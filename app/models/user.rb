class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

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
  validates_uniqueness_of :name, :email, :case_sensitive => false

  def superadmin?
    self.superadmin
  end

  def admins?(messageboard)
    superadmin? || roles.for(messageboard).as(['admin']).size > 0
  end

  def moderates?(messageboard)
    superadmin? || roles.for(messageboard).as([:admin, :moderator]).size > 0
  end

  def member_of?(messageboard)
    superadmin? || roles.for(messageboard).as([:admin, :moderator, :member]).size > 0
  end
  
  def member_of(messageboard, as='member')
    roles << Role.create(:level => as, :messageboard => messageboard) and save
  end

  def admin_of(messageboard, as=:member)
    member_of(messageboard, :admin)
  end

  def logged_in?
    valid?
  end

  def to_param
    name
  end

end
