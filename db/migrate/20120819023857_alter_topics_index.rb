class AlterTopicsIndex < ActiveRecord::Migration
  def change
    remove_index "topics", :name => "index_topics_on_messageboard_id"
    add_index "topics", ["messageboard_id", "updated_at"]
  end
end
