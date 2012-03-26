class Role < ActiveRecord::Base

  belongs_to :messageboard
  belongs_to :user
  # TODO : Figure out what's wrong with this HABTM relationship
  # has_and_belongs_to_many :users

  ROLES = ['superadmin', 'admin', 'moderator', 'member']
  validates_presence_of   :level
  validates_inclusion_of  :level, :in => ROLES
  validates_presence_of   :messageboard_id

  attr_accessible :level

  scope :for, lambda { |messageboard| where(:messageboard_id => messageboard.id) }
  scope :as,  lambda { |role| where(:level => role) }

  def self.touch_last_seen(user_id, messageboard_id)
    @user_role = Role.where("user_id = ? AND messageboard_id = ?", user_id, messageboard_id).first
    if @user_role
      @user_role.last_seen = Time.now
      @user_role.save!
    end
  end
end
