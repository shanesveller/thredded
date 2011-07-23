class CreateTopics < ActiveRecord::Migration
  def self.up
    create_table :topics do |t|
      t.integer  :user_id
      t.integer  :last_user_id
      t.string   :title
      t.integer  :post_count, :default => 0
      t.string   :permission, :default => 'public'

      t.timestamps
    end
  end

  def self.down
    drop_table :topics
  end
end
