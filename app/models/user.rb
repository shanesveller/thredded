class User < ActiveRecord::Base
  include ActiveModel::Dirty

  has_many :identities
  has_many :sites
  has_many :roles
  has_many :messageboards, through: :roles
  has_many :topics
  has_many :posts
  has_many :private_users
  has_many :private_topics, through: :private_users
  has_many :preferences

  accepts_nested_attributes_for :roles, allow_destroy: true

  after_save :update_posts

  attr_accessible :email,
    :name,
    :password,
    :password_confirmation,
    :post_filter,
    :provider,
    :remember_me,
    :roles_attributes,
    :time_zone,
    :uid

  default_scope include: :roles

  devise :database_authenticatable,
    :recoverable,
    :registerable,
    :rememberable,
    :token_authenticatable,
    :trackable

  validates :name,
    presence: true,
    uniqueness: true,
    format: {
      with: /\A[a-zA-Z0-9]+\z/,
      message: 'only letters or numbers allowed'
    }

  validates :email,
    presence: true,
    uniqueness: true,
    length: {
      minimum: 3,
      maximum: 254
    },
    format: {
      with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
      message: 'invalid email address'
    }

  def self.from_omniauth(auth_hash)
    where(email: auth_hash['info']['email']).first ||
      create_from_omniauth(auth_hash)
  end

  def mark_active_in!(messageboard)
    @user_role = roles.for(messageboard).first
    if @user_role
      @user_role.last_seen = Time.now
      @user_role.save!
    end
  end

  def at_notifications_for?(messageboard)
    preference_for(messageboard).notify_on_mention
  end

  def private_message_notifications_for?(messageboard)
    preference_for(messageboard).notify_on_message
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
    role = Role.new(level: as)
    role.messageboard = messageboard
    role.save
    roles << role
  end

  def admin_of(messageboard)
    member_of(messageboard, 'admin')
  end

  def to_param
    self.name
  end

  def can_read_messageboard?(messageboard)
    ( messageboard.restricted_to_private? && self.member_of?(messageboard) ) ||
    ( messageboard.restricted_to_logged_in? && self.valid? ) ||
      messageboard.public?
  end

  private

  def self.create_from_omniauth(auth_hash)
    create!(email: auth_hash['info']['email'], name: auth_hash['info']['nickname'])
  end

  def update_posts
    if self.email_changed?
      Post.update_all(["user_email = ?", self.email], ["user_email = ?", self.email_was])
    end
  end

  def preference_for(messageboard)
    self.preferences.where(messageboard_id: messageboard).first ||
      NullPreference.new
  end
end
