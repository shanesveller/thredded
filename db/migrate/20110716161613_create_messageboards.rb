class CreateMessageboards < ActiveRecord::Migration
  def self.up
    create_table :messageboards do |t|
      t.string  :name
      t.text    :description
      t.string  :theme
      t.integer :thread_count,        :default => 0
      t.string  :security,            :default => 'public'
      t.string  :posting_permission,  :default => 'anonymous'
      t.integer :site_id,             :default => 0

      t.timestamps
    end

    add_index :messageboards, [:name,:site_id], :unique => true
    add_index :messageboards, :thread_count
  end

  def self.down
    drop_table :messageboards
  end
end
