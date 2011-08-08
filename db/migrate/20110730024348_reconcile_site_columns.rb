class ReconcileSiteColumns < ActiveRecord::Migration
  def self.up
    add_column :sites, :slug, :string, :default => 'thredded'
    add_column :sites, :permission, :string, :default => 'public'
    remove_column :sites, :domain
  end

  def self.down
    remove_column :sites, :slug
    remove_column :sites, :permission
    add_column :sites, :domain, :string
  end
end
