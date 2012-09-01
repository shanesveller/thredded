class AddClosedFieldToMessageboards < ActiveRecord::Migration
  def change
    add_column :messageboards, :closed, :boolean, default: false, null: false
    add_index :messageboards, :closed
  end
end
