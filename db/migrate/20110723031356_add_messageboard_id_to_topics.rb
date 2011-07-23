class AddMessageboardIdToTopics < ActiveRecord::Migration
def self.up
    add_column :topics, :messageboard_id, :integer
  end
 
  def self.down
    remove_column :topics, :messageboard_id
  end
  end
