class Category < ActiveRecord::Base
  validates_presence_of :name, :description

  belongs_to :messageboard
  has_many :topics
end
