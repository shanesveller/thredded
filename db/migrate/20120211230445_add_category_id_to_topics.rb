class AddCategoryIdToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :category_id, :integer
    add_index  :topics, :category_id
  end
end
