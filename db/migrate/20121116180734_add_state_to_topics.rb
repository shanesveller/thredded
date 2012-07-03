class AddStateToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :state, :string, null: false, default: 'approved'
    add_index :topics, :state
  end
end
