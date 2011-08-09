class AddMessageboardIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :messageboard_id, :integer
  end
end
