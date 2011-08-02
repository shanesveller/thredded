class Site  < ActiveRecord::Base
  has_many :messageboards
  belongs_to  :user
  validates_presence_of :slug, :permission
end
