class Category < ActiveRecord::Base
  validates :name, presence: true

  belongs_to :messageboard
  has_many :topic_categories
  has_many :topics, through: :topic_categories
end
