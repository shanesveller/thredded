class AddNullFalseConstraintToPreferences < ActiveRecord::Migration
  def change
    change_column :preferences, :messageboard_id, :integer, null: false
  end
end
