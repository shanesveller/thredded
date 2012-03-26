class AddLastSeenToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :last_seen, :datetime
    add_index :roles, :last_seen
  end
end
