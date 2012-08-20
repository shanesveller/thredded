class RemoveCategoryIdFromTopics < ActiveRecord::Migration
  def up
    remove_column :topics, :category_id
  end

  def down
    add_column :topics, :category_id, :integer
    add_index  :topics, :category_id
  end
end
