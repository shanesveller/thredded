class AddPostFilterToUsers < ActiveRecord::Migration
  def change
    add_column :users, :post_filter, :string
  end
end
