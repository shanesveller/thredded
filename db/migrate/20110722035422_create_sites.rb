class CreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites do |t|
      t.integer :user_id
      t.string  :domain
    end
  end

  def self.down
    drop_table :sites
  end
end
