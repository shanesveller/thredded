class DeviseCreateUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      # Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: "", limit: 128

      # Recoverable
      t.string   :reset_password_token

      # Rememberable
      t.datetime :remember_created_at

      # Trackable
      t.integer  :sign_in_count, default: 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      # Token authenticatable
      t.string :authentication_token

      # Thredded specific
      t.string  :name
      t.boolean :superadmin, default: false, null: false
      t.integer :posts_count, default: 0

      t.timestamps
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :authentication_token, unique: true
  end

  def self.down
    drop_table :users
  end
end
