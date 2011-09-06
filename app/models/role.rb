class Role < ActiveRecord::Base
  # field :level, :type => Symbol

  belongs_to :messageboard
  belongs_to :user
  # TODO : Figure out what's wrong with this HABTM relationship
  # has_and_belongs_to_many :users

  ROLES = ['superadmin', 'admin', 'moderator', 'member']
  validates_presence_of   :level
  validates_inclusion_of  :level, :in => ROLES
  validates_presence_of   :messageboard_id

  scope :for, lambda { |messageboard| where(:messageboard_id => messageboard.id) }
  scope :as,  lambda { |role| where(:level => role) }
end
