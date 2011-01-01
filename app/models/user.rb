class User
  include Mongoid::Document
  include Mongoid::Timestamps

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, 
         :recoverable, :rememberable, :trackable, :validatable

  field :name, :type => String
  field :superadmin, :type => Boolean, :default => false
  references_many :messageboards, :stored_as => :array, :inverse_of => :users
  references_many :roles, :stored_as => :array, :inverse_of => :users
  
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

  def logged_in?
    valid?
  end

end
