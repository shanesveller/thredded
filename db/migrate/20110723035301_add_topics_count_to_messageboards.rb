class AddTopicsCountToMessageboards < ActiveRecord::Migration
  def self.up
    add_column :messageboards, :topics_count, :integer
  end

  def self.down
    remove_column :messageboards, :topics_count
  end
end
