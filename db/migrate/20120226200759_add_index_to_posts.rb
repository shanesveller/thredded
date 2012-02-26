class AddIndexToPosts < ActiveRecord::Migration
  def change
    add_index "posts", "topic_id"
  end
end
