class AddSlugToTopic < ActiveRecord::Migration
  def up
    add_column :topics, :slug, :string
    add_index :topics, :slug
  end

  def down
    remove_column :topics, :slug
  end
end
