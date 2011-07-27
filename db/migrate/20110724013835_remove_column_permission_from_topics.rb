class RemoveColumnPermissionFromTopics < ActiveRecord::Migration
  def self.up
    remove_column :topics, :permission
  end

  def self.down
    add_column :topics, :permission, :string, :default => 'public'
  end
end
