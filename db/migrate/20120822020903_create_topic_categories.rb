class CreateTopicCategories < ActiveRecord::Migration
  def self.up
    create_table :topic_categories do |t|
      t.integer :topic_id, :null => false
      t.integer :category_id, :null => false
    end

    add_index :topic_categories, :topic_id
  end

  def self.down
    drop_table :topic_categories
  end
end
