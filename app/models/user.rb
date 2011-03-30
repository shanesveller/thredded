class User
  include Mongoid::Document
  include Mongoid::Timestamps

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  field :name, :type => String
  field :superadmin, :type => Boolean, :default => false
  field :posts_count, :type => Integer, :default => 0

  references_and_referenced_in_many :messageboards
  references_and_referenced_in_many :roles
  references_and_referenced_in_many :topics
  
  validates_presence_of :name
  validates_uniqueness_of :name, :email, :case_sensitive => false
  attr_accessible :name, :email, :password, :password_confirmation

  def superadmin?
    self.superadmin
  end

  def admins?(messageboard)
    superadmin? || self.roles.for(messageboard).as([:admin]).size > 0
  end

  def moderates?(messageboard)
    superadmin? || self.roles.for(messageboard).as([:admin, :moderator]).size > 0
  end

  def member_of?(messageboard)
    superadmin? || self.roles.for(messageboard).as([:admin, :moderator, :member]).size > 0
  end
  
  def member_of(messageboard, as=:member)
    roles << Role.create(:level => as, :messageboard => messageboard)
    self.save
  end

  def admin_of(messageboard, as=:member)
    member_of(messageboard, :admin)
  end

  def logged_in?
    valid?
  end

end
