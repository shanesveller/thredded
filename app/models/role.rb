class Role < ActiveRecord::Base
  # field :level, :type => Symbol

  # belongs_to :messageboard
  has_and_belongs_to_many :users

  ROLES = [:superadmin, :admin, :moderator, :member]
  validates_presence_of   :level
  validates_inclusion_of  :level, :in => ROLES

  scope :for, lambda { |messageboard| where(:messageboard_id => messageboard.id) }
  scope :as,  lambda { |roles| any_in(:level => roles) }
end
