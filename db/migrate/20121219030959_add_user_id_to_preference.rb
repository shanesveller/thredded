class AddUserIdToPreference < ActiveRecord::Migration
  def change
    add_column :preferences, :user_id, :integer, null: false
    add_index :preferences, :user_id
  end
end
