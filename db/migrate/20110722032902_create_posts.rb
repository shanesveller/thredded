class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.integer :user_id
      t.string  :user_email
      t.text    :content
      t.string  :ip
      t.string  :filter, :default => 'bbcode'
      t.string  :source, :default => 'web'

      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
