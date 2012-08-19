class AddIndexToCategories < ActiveRecord::Migration
  def change
    add_index 'categories', 'messageboard_id'
  end
end
