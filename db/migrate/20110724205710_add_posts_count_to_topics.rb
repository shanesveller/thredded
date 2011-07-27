class AddPostsCountToTopics < ActiveRecord::Migration
  def self.up
    add_column :topics, :posts_count, :integer, :default => 0
    remove_column :topics, :post_count
  end

  def self.down
    remove_column :topics, :posts_count
    add_column :topics, :post_count, :integer, :default => 0
  end
end
