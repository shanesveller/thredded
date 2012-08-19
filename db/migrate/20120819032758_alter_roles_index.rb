class AlterRolesIndex < ActiveRecord::Migration
  def change
    remove_index "roles", :name => 'index_roles_on_messageboard_id'
    remove_index "roles", :name => 'index_roles_on_last_seen'
    add_index "roles", ["messageboard_id", "last_seen"]
  end
end
