class CreatePrivateUsers < ActiveRecord::Migration
  def self.up
    create_table :private_users do |t|
      t.integer :private_topic_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :private_users
  end
end
