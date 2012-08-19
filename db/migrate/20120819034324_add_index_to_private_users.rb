class AddIndexToPrivateUsers < ActiveRecord::Migration
  def change
    add_index "private_users", ["user_id", "private_topic_id"]
  end
end
