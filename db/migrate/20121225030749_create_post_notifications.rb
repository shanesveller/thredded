class CreatePostNotifications < ActiveRecord::Migration
  def change
    create_table :post_notifications do |t|
      t.string :email, null: false
      t.integer :post_id, null: false

      t.timestamps
    end
    add_index :post_notifications, :post_id
  end
end
