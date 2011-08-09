class AddColumnsToMessageboards < ActiveRecord::Migration
  def change
    add_column :messageboards, :posts_count, :integer, :default => 0
    remove_column :messageboards, :thread_count
  end
end
