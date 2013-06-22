class RemoveThemes < ActiveRecord::Migration
  def up
    remove_column :messageboards, :theme
  end

  def down
    add_column :messageboards, :theme, :string
  end
end
