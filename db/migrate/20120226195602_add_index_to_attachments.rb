class AddIndexToAttachments < ActiveRecord::Migration
  def change
    add_index "attachments", "post_id"
  end
end
