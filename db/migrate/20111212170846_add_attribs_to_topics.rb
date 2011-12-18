class AddAttribsToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :attribs, :string, :default => "[]"
    add_column :topics, :sticky,  :boolean, :default => false
  end
end
