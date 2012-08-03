class CreateUserTopicReads < ActiveRecord::Migration
  def change
    create_table :user_topic_reads do |t|
      t.integer :user_id, null: false
      t.integer :topic_id, null: false
      t.integer :post_id, null: false
      t.integer :posts_count, null: false, default: 0
      t.integer :page, null: false, default: 1

      t.timestamps
    end

    add_index :user_topic_reads, :user_id
    add_index :user_topic_reads, :topic_id
    add_index :user_topic_reads, :post_id
    add_index :user_topic_reads, :posts_count
    add_index :user_topic_reads, :page
  end
end
