class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :level
      t.integer :user_id
      t.integer :messageboard_id
  
      t.timestamps
    end

    add_index :roles, :messageboard_id
    add_index :roles, :user_id
  end

  def self.down
    drop_table :roles
  end
end
