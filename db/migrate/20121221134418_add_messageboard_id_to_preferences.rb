class AddMessageboardIdToPreferences < ActiveRecord::Migration
  def change
    add_column :preferences, :messageboard_id, :integer
    add_index :preferences, :messageboard_id
  end
end
