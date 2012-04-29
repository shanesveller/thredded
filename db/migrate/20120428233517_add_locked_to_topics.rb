class AddLockedToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :locked, :boolean
  end
end
