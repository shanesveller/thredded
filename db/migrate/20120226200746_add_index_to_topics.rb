class AddIndexToTopics < ActiveRecord::Migration
  def change
    add_index  "topics", "messageboard_id"
  end
end
