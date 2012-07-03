class EnforceNullFalseInTopics < ActiveRecord::Migration
  def up
    change_column :topics, :user_id, :integer, null: false
    change_column :topics, :last_user_id, :integer, null: false
    change_column :topics, :messageboard_id, :integer, null: false
    change_column :topics, :title, :string, null: false
    change_column :topics, :hash_id, :string, null: false
  end

  def down
    change_column :topics, :user_id, :integer, null: true
    change_column :topics, :last_user_id, :integer, null: true
    change_column :topics, :messageboard_id, :integer, null: true
    change_column :topics, :title, :string, null: true
    change_column :topics, :hash_id, :string, null: true
  end
end
