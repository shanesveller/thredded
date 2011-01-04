class Role
  include Mongoid::Document
  field :level, :type => Symbol

  referenced_in :messageboard

  referenced_in :user
  references_many :users

  ROLES = [:superadmin, :admin, :moderator, :member]
  validates_presence_of   :level
  validates_inclusion_of  :level, :in => ROLES

  scope :for, lambda { |messageboard| where(:messageboard_id => messageboard.id) }
  scope :as,  lambda { |roles| any_in(:level => roles) }
end
